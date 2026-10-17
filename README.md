<div align="center">

[![Arch Linux](assets/arch-linux.webp)](https://archlinux.org)

### **Arch Linux Packages**

**[Repository](https://github.com/odevsa/arch-repo/releases/tag/packages)**

[![Arch Linux](https://img.shields.io/badge/Repository-Arch%20Linux-1793d1?logo=arch-linux&logoColor=white&style=flat-square)](https://archlinux.org)
[![Release](https://img.shields.io/github/v/release/odevsa/arch-repo?include_prereleases&label=Release&logo=github&style=flat-square)](https://github.com/odevsa/arch-repo/releases/tag/packages)
[![Last Commit](https://img.shields.io/github/last-commit/odevsa/arch-repo?label=Updated%20at&logo=googlecalendar&logoColor=white&style=flat-square)](https://github.com/odevsa/arch-repo/commits/main)
[![Build and Release](https://img.shields.io/github/actions/workflow/status/odevsa/arch-repo/deploy.yml?branch=main&label=Build&logo=githubactions&logoColor=white&style=flat-square)](https://github.com/odevsa/arch-repo/actions/workflows/deploy.yml)

</div>

### Overview

This repository contains packaging metadata and binaries for Arch Linux packages used in this project. The `packages/` directory contains package files and PKGBUILD scripts. A top-level `Makefile` provides convenient targets for building and managing the repository.

### Tasks (Just & Makefile)

The canonical tasks are defined in `justfile` ([just](https://github.com/casey/just)). A `Makefile` wrapper is also provided for convenience:

- `make build` / `just build`: Build all packages and update repo database
- `make build <package>` / `just build <package>`: Build a specific package
- `make install <package>` / `just install <package>`: Update, build, and install a package locally
- `make update` / `just update`: Update all package versions
- `make update <package>` / `just update <package>`: Update a specific package version
- `make clean` / `just clean`: Remove built packages and output directories
- `make help` / `just help`: Show available tasks

### Adding this repo to /etc/pacman.conf

Add the following to `/etc/pacman.conf`:

```ini
[odevsa]
SigLevel = Optional TrustAll
Server = https://github.com/odevsa/arch-repo/releases/download/packages
```

Then refresh the package databases and install packages:

```bash
sudo pacman -Sy
sudo pacman -S <package-name>
```
