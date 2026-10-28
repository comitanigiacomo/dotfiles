#!/usr/bin/env bash
# Ripristino completo su un PC nuovo.
#   bash bootstrap/restore-all.sh          (chiede conferma a ogni passo)
#   bash bootstrap/restore-all.sh --yes    (tutto di fila)
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
AUTO=0
[ "${1:-}" = "--yes" ] && AUTO=1

STEPS=(
    10-repos.sh
    20-packages.sh
    30-flatpaks.sh
    40-restore-home.sh
    50-shell.sh
    60-desktop.sh
    70-apps.sh
    80-verify.sh
)

echo "Ripristino completo da $DIR"
echo "Password restic: Bitwarden -> 'restic laptop'"
echo

for s in "${STEPS[@]}"; do
    if [ "$AUTO" -eq 0 ]; then
        read -rp "Eseguo $s ? [Invio = si, n = salta] " a
        [ "$a" = "n" ] && { echo "saltato"; continue; }
    fi
    echo
    echo "############ $s ############"
    bash "$DIR/$s"
done

echo
echo "Ripristino terminato. Riavvia e fai login."
