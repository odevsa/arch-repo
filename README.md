<div align="center">

### **Arch Linux Packages**

**[Repository](https://github.com/odevsa/arch-repo/releases/tag/packages)**

[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Repository-1793d1?logo=arch-linux&logoColor=white&style=flat-square)](https://archlinux.org)
[![Build and Release](https://img.shields.io/github/actions/workflow/status/odevsa/arch-repo/deploy.yml?branch=main&label=build&logo=githubactions&logoColor=white&style=flat-square)](https://github.com/odevsa/arch-repo/actions/workflows/deploy.yml)
[![Release](https://img.shields.io/github/v/release/odevsa/arch-repo?include_prereleases&label=release&logo=github&style=flat-square)](https://github.com/odevsa/arch-repo/releases/tag/packages)
[![Last Commit](https://img.shields.io/github/last-commit/odevsa/arch-repo?label=last%20update&logo=git&style=flat-square)](https://github.com/odevsa/arch-repo/commits/main)

</div>

### Overview

This repository contains packaging metadata and binaries for Arch Linux packages used in this project. The `packages/` directory contains package files and PKGBUILD scripts. A top-level `Makefile` provides convenient targets for building and managing the repository.

### Makefile

See the `Makefile` at the repository root for available targets. Typical usage:

- `make build`: Build all packages and update repo database
- `make <packages>`: Build specific packages
- `make update`: Update all packages versions
- `make clean`: Remove built packages and output directories
- `make help`: Show this help message

Check the `Makefile` to see the exact target names and behaviors.

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
