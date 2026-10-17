set shell := ["bash", "-euo", "pipefail", "-c"]

packages_dir := "packages"
output_dir := "public"
repo_name := "odevsa"

# Show available recipes
default:
    @just --list

# Show help
help:
    @just --list

# Build all packages, or a specific package: `just build [package]`
build package="":
    #!/usr/bin/env bash
    set -euo pipefail
    TARGET="{{package}}"
    if [ -n "$TARGET" ]; then
        if [ ! -d "{{packages_dir}}/$TARGET" ] || [ ! -f "{{packages_dir}}/$TARGET/PKGBUILD" ]; then
            echo "Error: Package '$TARGET' not found or missing PKGBUILD in {{packages_dir}}/." >&2
            exit 1
        fi
        echo "==> Building package: $TARGET"
        mkdir -p "{{output_dir}}"
        cp "{{packages_dir}}/$TARGET"/sources/* "{{packages_dir}}/$TARGET"/ 2>/dev/null || true
        (cd "{{packages_dir}}/$TARGET" && makepkg -s --noconfirm -c)
        mv "{{packages_dir}}/$TARGET"/*.pkg.tar.zst "{{output_dir}}/" 2>/dev/null || true
        for ext in install sh zip deb rpm AppImage tar.* part desktop png xml; do
            rm -f "{{packages_dir}}/$TARGET"/*.$ext
        done
    else
        just clean
        IGNORED=()
        if [ -f "{{packages_dir}}/.ignore" ]; then
            mapfile -t IGNORED < "{{packages_dir}}/.ignore"
        fi
        for pkgdir in {{packages_dir}}/*; do
            [ -d "$pkgdir" ] || continue
            [ -f "$pkgdir/PKGBUILD" ] || continue
            pkg=$(basename "$pkgdir")
            is_ignored=0
            for ign in "${IGNORED[@]}"; do
                if [ "$pkg" = "$ign" ]; then
                    is_ignored=1
                    break
                fi
            done
            if [ "$is_ignored" -eq 1 ]; then
                continue
            fi
            echo "==> Building package: $pkg"
            mkdir -p "{{output_dir}}"
            cp "$pkgdir"/sources/* "$pkgdir"/ 2>/dev/null || true
            (cd "$pkgdir" && makepkg -s --noconfirm -c)
            mv "$pkgdir"/*.pkg.tar.zst "{{output_dir}}/" 2>/dev/null || true
            for ext in install sh zip deb rpm AppImage tar.* part desktop png xml; do
                rm -f "$pkgdir"/*.$ext
            done
        done
        just database
    fi

# Update, build, and install package locally: `just install <package>`
install package="":
    #!/usr/bin/env bash
    set -euo pipefail
    TARGET="{{package}}"
    if [ -z "$TARGET" ]; then
        echo "Error: Please specify a package to install (e.g. just install <package>)" >&2
        exit 1
    fi
    just update "$TARGET"
    just build "$TARGET"
    PKG_FILE=$(ls -t "{{output_dir}}/${TARGET}"-*.pkg.tar.zst 2>/dev/null | head -n 1)
    if [ -z "$PKG_FILE" ] || [ ! -f "$PKG_FILE" ]; then
        echo "Error: Built package file for '$TARGET' not found in {{output_dir}}/." >&2
        exit 1
    fi
    echo "==> Installing $PKG_FILE..."
    sudo pacman -U "$PKG_FILE"

# Update all packages versions, or a specific package: `just update [package]`
update package="":
    #!/usr/bin/env bash
    set -euo pipefail
    TARGET="{{package}}"
    if [ -n "$TARGET" ]; then
        if [ ! -d "{{packages_dir}}/$TARGET" ]; then
            echo "Error: Package '$TARGET' not found in {{packages_dir}}/." >&2
            exit 1
        fi
        if [ -f "{{packages_dir}}/$TARGET/update" ]; then
            echo "==> Verifying $TARGET..."
            bash "{{packages_dir}}/$TARGET/update"
        else
            echo "==> No update script found for $TARGET ({{packages_dir}}/$TARGET/update)."
        fi
    else
        IGNORED=()
        if [ -f "{{packages_dir}}/.ignore" ]; then
            mapfile -t IGNORED < "{{packages_dir}}/.ignore"
        fi
        for pkgdir in {{packages_dir}}/*; do
            [ -d "$pkgdir" ] || continue
            pkg=$(basename "$pkgdir")
            is_ignored=0
            for ign in "${IGNORED[@]}"; do
                if [ "$pkg" = "$ign" ]; then
                    is_ignored=1
                    break
                fi
            done
            if [ "$is_ignored" -eq 1 ]; then
                continue
            fi
            if [ -f "$pkgdir/update" ]; then
                echo "==> Verifying $pkg..."
                bash "$pkgdir/update"
            fi
        done
    fi

# Update repo database
database:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p "{{output_dir}}"
    cd "{{output_dir}}"
    rm -f "{{repo_name}}".db* "{{repo_name}}".files*
    if compgen -G "*.pkg.tar.zst" > /dev/null; then
        repo-add "{{repo_name}}.db.tar.gz" *.pkg.tar.zst
    else
        echo "No packages found in {{output_dir}}/ to add to database."
    fi

# Remove built packages and output directories
clean:
    #!/usr/bin/env bash
    set -euo pipefail
    rm -rf "{{output_dir}}"
    rm -rf {{packages_dir}}/*/{src,pkg}
    for pkgdir in {{packages_dir}}/*; do
        if [ -d "$pkgdir" ]; then
            for ext in install sh zip deb rpm AppImage tar.* part desktop png xml; do
                rm -f "$pkgdir"/*.$ext
            done
        fi
    done

# Show version or package version: `just version [package]`
version package="":
    #!/usr/bin/env bash
    set -euo pipefail
    TARGET="{{package}}"
    if [ -n "$TARGET" ]; then
        if [ -f "{{packages_dir}}/$TARGET/PKGBUILD" ]; then
            grep -E '^pkgver=' "{{packages_dir}}/$TARGET/PKGBUILD" | cut -d= -f2 | tr -d '"'
        else
            echo "Error: Package '$TARGET' not found." >&2
            exit 1
        fi
    else
        git describe --tags --always 2>/dev/null || echo "1.0.0"
    fi
