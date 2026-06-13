#!/usr/bin/env bash
set -euo pipefail

# Latest version
DIRECTORY=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PACKAGE=$(basename "$DIRECTORY")
RESPONSE_URL="https://dl.google.com/linux/chrome/deb/dists/stable/main/binary-amd64/Packages.gz"
RESPONSE=$(curl -sSL "$RESPONSE_URL" | gunzip -c 2>/dev/null || true)
LATEST_VERSION=$(printf '%s' "$RESPONSE" | awk '/^Package: google-chrome-stable/{p=1} p && /^Version:/{print $2; exit}' | sed 's/-[^-]*$//')

if [ -z "$LATEST_VERSION" ]; then
  exit 1
fi

# Apply update
PKGBUILD_FILE="$DIRECTORY/PKGBUILD"
CURRENT_VERSION=$(grep -E '^pkgver=' "$PKGBUILD_FILE" | cut -d= -f2 | tr -d '"')
if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
	sed -i "s/^pkgver=.*/pkgver=${LATEST_VERSION}/" "$PKGBUILD_FILE"
  echo "[${PACKAGE}] Updated: ${CURRENT_VERSION} -> ${LATEST_VERSION}"
fi