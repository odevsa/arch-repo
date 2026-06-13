#!/usr/bin/env bash
set -euo pipefail

# Latest version
DIRECTORY=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PACKAGE=$(basename "$DIRECTORY")
PLATFORM=${1:-linux-x64}
URL="https://update.code.visualstudio.com/api/update/${PLATFORM}/stable/latest"
RESPONSE=$(curl -sSL "${URL}")
LATEST_VERSION=$(printf '%s' "$RESPONSE" | sed -n 's/.*"productVersion"[[:space:]]*:[[:space:]]*"\([^\"]*\)".*/\1/p; t; s/.*"version"[[:space:]]*:[[:space:]]*"\([^\"]*\)".*/\1/p; t; s/.*"name"[[:space:]]*:[[:space:]]*"\([^\"]*\)".*/\1/p')

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