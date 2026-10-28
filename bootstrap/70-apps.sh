#!/usr/bin/env bash
# Servizi e configurazioni applicative che richiedono un passaggio manuale o un login.
source "$(dirname "$0")/00-common.sh"

log "Docker"
if have docker || rpm -q moby-engine >/dev/null 2>&1; then
    $SUDO systemctl enable --now docker || warn "docker non parte"
    if ! id -nG "$TARGET_USER" | grep -qw docker; then
        $SUDO usermod -aG docker "$TARGET_USER"
        warn "Utente aggiunto al gruppo docker: serve un nuovo login."
    fi
else
    warn "Docker non installato (manca dalla lista pacchetti?)"
fi

log "Tailscale"
if have tailscale; then
    $SUDO systemctl enable --now tailscaled || warn "tailscaled non parte"
    if ! $SUDO tailscale status >/dev/null 2>&1; then
        warn "Serve il login Tailscale: apri il link che verra' mostrato."
        $SUDO tailscale up || warn "tailscale up non completato: rilancia 'sudo tailscale up'"
    fi
else
    warn "Tailscale non installato"
fi

log "Estensioni VS Code"
if have code && [ -s "$REPO_DIR/packages/vscode-extensions.txt" ]; then
    xargs -r -n1 code --install-extension < "$REPO_DIR/packages/vscode-extensions.txt" || warn "Alcune estensioni VS Code non installate"
else
    warn "code o lista estensioni mancanti"
fi

log "mise"
if have mise && [ -f "$HOME/.config/mise/config.toml" ]; then
    mise install || warn "mise install non completato"
else
    warn "mise non installato o nessuna config"
fi

log "Applicazioni configurate"
cat <<'EOF'

Passaggi che restano manuali (richiedono un login o un download):
  1. Nextcloud: apri il client, accedi a https://cloud.jack-lab.dev e ricontrolla
     le due cartelle sincronizzate (~/projects -> /backup_projects,
     ~/Documents -> /backup_documents).
  2. Android Studio: al primo avvio riscarica l'SDK in ~/Android/Sdk.
  3. Profili Flatpak (Zen, Telegram, Prism/Minecraft): non sono nel backup.
  4. Bitwarden: sbloccalo e verifica le voci "restic laptop" e "restic".
EOF
