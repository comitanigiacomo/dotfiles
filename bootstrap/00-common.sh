#!/usr/bin/env bash
set -euo pipefail

BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$BOOTSTRAP_DIR/.." && pwd)"
TARGET_USER="${TARGET_USER:-$(id -un)}"
TARGET_HOME="${TARGET_HOME:-/home/$TARGET_USER}"

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

log() { echo "[*] $*"; }
warn() { echo "[!] $*"; }
die() { echo "[x] $*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }
