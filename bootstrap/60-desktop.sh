#!/usr/bin/env bash
source "$(dirname "$0")/00-common.sh"

[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ] || warn "sessione grafica non rilevata"

log "impostazioni gnome"
if [ -f "$REPO_DIR/gnome/gnome-settings.ini" ]; then
    dconf load / < "$REPO_DIR/gnome/gnome-settings.ini" || warn "dconf load parziale"
fi

log "estensioni gnome"
LIST="$REPO_DIR/packages/gnome-extensions.txt"
if [ ! -s "$LIST" ] || ! have gnome-extensions; then
    warn "lista estensioni o gnome-extensions mancanti"
    exit 0
fi

VER="$(gnome-shell --version 2>/dev/null | awk '{print $3}' | cut -d. -f1)"
TMP="$(mktemp -d)"

while read -r uuid; do
    [ -n "$uuid" ] || continue
    info="$(curl -fsSL "https://extensions.gnome.org/extension-info/?uuid=${uuid}&shell_version=${VER}" 2>/dev/null)" || {
        warn "$uuid: nessuna versione per gnome $VER"; continue; }
    url="$(printf '%s' "$info" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("download_url",""))' 2>/dev/null)"
    [ -n "$url" ] || { warn "$uuid: download non disponibile"; continue; }
    curl -fsSL -o "$TMP/e.zip" "https://extensions.gnome.org${url}" || { warn "$uuid: download fallito"; continue; }
    gnome-extensions install --force "$TMP/e.zip" || { warn "$uuid: installazione fallita"; continue; }
    gnome-extensions enable "$uuid" 2>/dev/null || warn "$uuid: abilitala dopo il riavvio della shell"
    rm -f "$TMP/e.zip"
done < "$LIST"

rm -rf "$TMP"
