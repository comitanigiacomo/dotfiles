#!/usr/bin/env bash
# Helper comune per gli script di bootstrap. Va caricato con "source", non eseguito.
set -euo pipefail

BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$BOOTSTRAP_DIR/.." && pwd)"
TARGET_USER="${TARGET_USER:-$(id -un)}"
TARGET_HOME="${TARGET_HOME:-/home/$TARGET_USER}"

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

log()  { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m[!] %s\033[0m\n' "$*"; }
die()  { printf '\033[1;31m[x] %s\033[0m\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }
