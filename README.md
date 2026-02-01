# BitL PHP Builds

Pre-built static PHP binaries for [BitL](https://github.com/karajanchang/BitL) — a macOS Laravel development environment.

## Overview

This repository automates building statically-compiled PHP binaries (CLI + FPM) for macOS using [static-php-cli](https://github.com/crazywhalecc/static-php-cli). Binaries are built for both **arm64** (Apple Silicon) and **x86_64** (Intel) architectures.

## How Builds Work

1. GitHub Actions downloads the `spc` (static-php-cli) binary
2. PHP sources and extension dependencies are fetched
3. PHP CLI and PHP-FPM are compiled as static binaries
4. Binaries are packaged as `.tar.gz` and uploaded to GitHub Releases

### Triggering Builds

- **Single version:** Run the "Build PHP" workflow with a version input (e.g., `8.4.3`)
- **All versions:** Run the "Build All PHP Versions" workflow

## Available Versions

| Version | arm64 | x86_64 |
|---------|-------|--------|
| 8.4.3   | ✅    | ✅     |
| 8.3.15  | ✅    | ✅     |
| 8.2.28  | ✅    | ✅     |

## Included Extensions

bcmath, calendar, ctype, curl, dom, exif, fileinfo, filter, gd, iconv, intl, mbregex, mbstring, mysqlnd, mysqli, opcache, openssl, pcntl, pdo, pdo_mysql, pdo_pgsql, pdo_sqlite, phar, posix, readline, redis, session, simplexml, sockets, sodium, sqlite3, tokenizer, xml, xmlreader, xmlwriter, zip, zlib

## Local Build

```bash
./scripts/build.sh 8.4.3
```

## Verify a Binary

```bash
./scripts/verify.sh dist/bin/php
```

## Manifest

The `config/php-versions.json` file contains a machine-readable manifest of all available versions, download URLs, and SHA256 checksums. BitL reads this manifest to download and verify PHP binaries.

