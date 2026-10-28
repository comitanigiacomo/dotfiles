#!/usr/bin/env bash
# Reinstalla le applicazioni Flatpak.
source "$(dirname "$0")/00-common.sh"

LIST="$REPO_DIR/packages/flatpaks.txt"
[ -s "$LIST" ] || die "Lista Flatpak vuota o assente: $LIST"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

log "Installo $(wc -l < "$LIST") Flatpak da Flathub"
xargs -r -n1 flatpak install -y --noninteractive flathub < "$LIST" || warn "Qualche Flatpak non e' stato installato"

log "Flatpak installati"
