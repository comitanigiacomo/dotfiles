#!/usr/bin/env bash
# Impostazioni GNOME (dconf) + estensioni.
source "$(dirname "$0")/00-common.sh"

if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    warn "Sessione grafica non rilevata: dconf/estensioni richiedono un login desktop."
fi

log "Impostazioni GNOME"
if [ -f "$REPO_DIR/gnome/gnome-settings.ini" ]; then
    dconf load / < "$REPO_DIR/gnome/gnome-settings.ini" || warn "dconf load parziale"
else
    warn "gnome/gnome-settings.ini assente"
fi

log "Estensioni GNOME"
LIST="$REPO_DIR/packages/gnome-extensions.txt"
if [ -s "$LIST" ] && have gnome-extensions && have curl; then
    SHELL_VER="$(gnome-shell --version 2>/dev/null | awk '{print $3}' | cut -d. -f1)"
    [ -n "$SHELL_VER" ] || SHELL_VER="50"
    TMP="$(mktemp -d)"
    while read -r uuid; do
        [ -n "$uuid" ] || continue
        info="$(curl -fsSL "https://extensions.gnome.org/extension-info/?uuid=${uuid}&shell_version=${SHELL_VER}" 2>/dev/null)" || {
            warn "estensioni.gnome.org: nessuna versione per $uuid (GNOME $SHELL_VER)"
            continue
        }
        url="$(printf '%s' "$info" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("download_url",""))' 2>/dev/null)"
        if [ -z "$url" ]; then
            warn "$uuid: download non disponibile"
            continue
        fi
        curl -fsSL -o "$TMP/e.zip" "https://extensions.gnome.org${url}" || { warn "$uuid: download fallito"; continue; }
        gnome-extensions install --force "$TMP/e.zip" || { warn "$uuid: installazione fallita"; continue; }
        gnome-extensions enable "$uuid" 2>/dev/null || warn "$uuid: installata, abilitala dopo il riavvio della shell"
        rm -f "$TMP/e.zip"
    done < "$LIST"
    rm -rf "$TMP"
    warn "Alcune estensioni richiedono un riavvio della shell per attivarsi."
else
    warn "Lista estensioni assente o strumenti mancanti"
fi

log "Desktop configurato"
