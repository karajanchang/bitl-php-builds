#!/bin/bash
set -euo pipefail

VERSION="${1:?Usage: build.sh <php-version>}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="${REPO_DIR}/dist"
ARCH="$(uname -m)"

echo "==> Building PHP ${VERSION} for ${ARCH}"

# Download spc
echo "==> Downloading static-php-cli..."
curl -fSL "https://dl.static-php.dev/static-php-cli/spc-bin/nightly/spc-macos-${ARCH}" -o spc
chmod +x spc

# Read extensions
EXTENSIONS=$(cat "${REPO_DIR}/config/extensions.txt" | tr '\n' ',' | sed 's/,$//')

# Download sources
echo "==> Downloading PHP sources and dependencies..."
./spc download --with-php="${VERSION}" --for-extensions="${EXTENSIONS}"

# Build
echo "==> Building PHP CLI and FPM..."
./spc build php-cli php-fpm --build-cli --build-fpm --with-extensions="${EXTENSIONS}"

# Package
echo "==> Packaging..."
mkdir -p "${DIST_DIR}/bin"
cp buildroot/bin/php "${DIST_DIR}/bin/"
cp buildroot/bin/php-fpm "${DIST_DIR}/bin/"

cd "${DIST_DIR}"
tar -czf "php-${VERSION}-macos-${ARCH}.tar.gz" bin/

echo "==> Done! Output: ${DIST_DIR}/php-${VERSION}-macos-${ARCH}.tar.gz"
