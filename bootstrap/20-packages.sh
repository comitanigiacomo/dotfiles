#!/usr/bin/env bash
# Reinstalla i pacchetti rpm salvati in packages/dnf-packages.txt
source "$(dirname "$0")/00-common.sh"

LIST="$REPO_DIR/packages/dnf-packages.txt"
[ -s "$LIST" ] || die "Lista pacchetti vuota o assente: $LIST"

mapfile -t PKGS < "$LIST"
log "Installo ${#PKGS[@]} pacchetti rpm (puo' richiedere 20-40 minuti)"

if ! $SUDO dnf -y install --skip-unavailable "${PKGS[@]}"; then
    warn "Alcuni pacchetti non sono stati installati (repo mancante o pacchetto rimosso)."
    warn "Controlla l'output sopra, oppure rilancia dopo aver sistemato i repo."
fi

log "Pacchetti installati"
