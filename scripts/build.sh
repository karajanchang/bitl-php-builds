#!/bin/bash
set -euo pipefail
export PATH="/usr/sbin:/usr/bin:/sbin:/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

VERSION="${1:?Usage: build.sh <php-version>}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="${REPO_DIR}/dist"
ARCH="$(uname -m)"

echo "==> Building PHP ${VERSION} for ${ARCH}"

# Download spc
echo "==> Downloading static-php-cli v2.8.1..."
SPC_ARCH="${ARCH}"
[[ "${SPC_ARCH}" == "arm64" ]] && SPC_ARCH="aarch64"
curl -fSL "https://github.com/crazywhalecc/static-php-cli/releases/download/2.8.1/spc-macos-${SPC_ARCH}.tar.gz" -o spc.tar.gz
tar -xzf spc.tar.gz
chmod +x spc
rm -f spc.tar.gz

# Read extensions
EXTENSIONS=$(cat "${REPO_DIR}/config/extensions.txt" | tr '\n' ',' | sed 's/,$//')

# Download sources
echo "==> Downloading PHP sources and dependencies..."
./spc download --with-php="${VERSION}" --for-extensions="${EXTENSIONS}"

# Build
echo "==> Building PHP CLI and FPM..."
./spc build --build-cli --build-fpm "${EXTENSIONS}"

# Package
echo "==> Packaging..."
mkdir -p "${DIST_DIR}/bin"
cp buildroot/bin/php "${DIST_DIR}/bin/"
cp buildroot/bin/php-fpm "${DIST_DIR}/bin/"

cd "${DIST_DIR}"
tar -czf "php-${VERSION}-macos-${ARCH}.tar.gz" bin/

echo "==> Done! Output: ${DIST_DIR}/php-${VERSION}-macos-${ARCH}.tar.gz"
