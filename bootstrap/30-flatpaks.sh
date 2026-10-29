#!/usr/bin/env bash
source "$(dirname "$0")/00-common.sh"

LIST="$REPO_DIR/packages/flatpaks.txt"
[ -s "$LIST" ] || die "lista flatpak mancante: $LIST"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

log "installo $(wc -l < "$LIST") flatpak"
xargs -r -n1 flatpak install -y --noninteractive flathub < "$LIST" || warn "qualche flatpak non installato"
