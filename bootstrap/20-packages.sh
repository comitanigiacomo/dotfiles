#!/usr/bin/env bash
source "$(dirname "$0")/00-common.sh"

LIST="$REPO_DIR/packages/dnf-packages.txt"
[ -s "$LIST" ] || die "lista pacchetti mancante: $LIST"

mapfile -t PKGS < "$LIST"
log "installo ${#PKGS[@]} pacchetti rpm"

$SUDO dnf -y install --skip-unavailable "${PKGS[@]}" || warn "alcuni pacchetti non installati"
