<div align="center">

[![Arch Linux](assets/arch-linux.webp)](https://archlinux.org)

### **Arch Linux Packages**

**[Repository](https://github.com/odevsa/arch-repo/releases/tag/packages)**

[![Arch Linux](https://img.shields.io/badge/Repository-Arch%20Linux-1793d1?logo=arch-linux&logoColor=white&style=flat-square)](https://archlinux.org)
[![Release](https://img.shields.io/github/v/release/odevsa/arch-repo?label=Release&logo=github&style=flat-square)](https://github.com/odevsa/arch-repo/releases/tag/packages)
[![Last Commit](https://img.shields.io/github/last-commit/odevsa/arch-repo?label=Updated%20at&logo=googlecalendar&logoColor=white&style=flat-square)](https://github.com/odevsa/arch-repo/commits/main)
[![Build and Release](https://img.shields.io/github/actions/workflow/status/odevsa/arch-repo/deploy.yml?branch=main&label=Build&logo=githubactions&logoColor=white&style=flat-square)](https://github.com/odevsa/arch-repo/actions/workflows/deploy.yml)

</div>

### Overview

This repository contains packaging metadata, PKGBUILD scripts, and automated binary releases for custom Arch Linux packages. Binary packages and repository databases (`odevsa.db.tar.gz`) are automatically built and published via GitHub Actions to the continuous [packages](https://github.com/odevsa/arch-repo/releases/tag/packages) release.

### Adding this repo to /etc/pacman.conf

Add the repository configuration to `/etc/pacman.conf`:

```ini
[odevsa]
SigLevel = Optional TrustAll
Server = https://github.com/odevsa/arch-repo/releases/download/packages
```

Synchronize pacman databases and install packages:

```bash
sudo pacman -Sy
sudo pacman -S <package-name>
```

### Tasks (Just & Makefile)

The canonical tasks are defined in `justfile` ([just](https://github.com/casey/just)). A `Makefile` wrapper is also provided for convenience:

| Task (Makefile)          | Task (Just)              | Description                                                  |
| :----------------------- | :----------------------- | :----------------------------------------------------------- |
| `make build`             | `just build`             | Build all active packages and regenerate the repo database   |
| `make build <package>`   | `just build <package>`   | Build a specific package into `public/`                      |
| `make install <package>` | `just install <package>` | Update, build, and install a package locally via `pacman -U` |
| `make update`            | `just update`            | Run update scripts for all active packages                   |
| `make update <package>`  | `just update <package>`  | Run the update script for a specific package                 |
| `make version [package]` | `just version [package]` | Show repository version or package `pkgver`                  |
| `make clean`             | `just clean`             | Remove build artifacts and output directories                |
| `make help`              | `just help`              | Show list of available recipes                               |
