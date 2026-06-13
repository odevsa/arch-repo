# arch-repo

Project: arch-repo

GitHub Pages: https://odevsa.github.io/arch-repo

### Overview

This repository contains packaging metadata and binaries for Arch Linux packages used in this project. The `packages/` directory contains package files and PKGBUILD scripts. A top-level `Makefile` provides convenient targets for building and managing the repository.

### Makefile

See the `Makefile` at the repository root for available targets. Typical usage:

- `make build`: Build all packages and update repo database
- `make <packages>`: Build specific packages
- `make update`: Update all packages versions
- `make clean`: Remove built packages and output directories
- `make html`: Generate HTML index of packages
- `make help`: Show this help message

Check the `Makefile` to see the exact target names and behaviors.

### Adding this repo to /etc/pacman.conf

Add the following to `/etc/pacman.conf`:

```
[odevsa]
SigLevel = Optional TrustAll
Server = https://odevsa.github.io/arch-repo
```

Then refresh the package databases and install packages:

```bash
sudo pacman -Sy
sudo pacman -S <package-name>
```
