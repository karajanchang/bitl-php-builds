#!/bin/bash
set -euo pipefail

PHP_BIN="${1:?Usage: verify.sh <path-to-php-binary>}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "==> Verifying PHP binary: ${PHP_BIN}"

# Check version
echo "--- PHP Version ---"
"${PHP_BIN}" -v
echo ""

# Check modules
echo "--- Loaded Extensions ---"
LOADED=$("${PHP_BIN}" -m 2>/dev/null)
echo "${LOADED}"
echo ""

# Verify expected extensions
echo "--- Extension Check ---"
EXPECTED_EXTENSIONS=$(cat "${REPO_DIR}/config/extensions.txt")
MISSING=0

for ext in ${EXPECTED_EXTENSIONS}; do
    # Some extension names differ between config and php -m output
    if echo "${LOADED}" | grep -qi "^${ext}$"; then
        echo "  ✓ ${ext}"
    else
        echo "  ✗ ${ext} (MISSING)"
        MISSING=$((MISSING + 1))
    fi
done

echo ""
if [ "${MISSING}" -gt 0 ]; then
    echo "⚠️  ${MISSING} extension(s) missing"
    exit 1
else
    echo "✅ All extensions loaded"
fi
