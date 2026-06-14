#!/usr/bin/env bash
set -euo pipefail

# Latest version
DIRECTORY=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PACKAGE=$(basename "$DIRECTORY")
RESPONSE=$(curl -sSL "https://api.github.com/repos/odevsa/gamepad/releases/latest")
LATEST_VERSION=$(printf '%s' "$RESPONSE" | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^\"]*\)".*/\1/p')
LATEST_VERSION=${LATEST_VERSION#v}

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