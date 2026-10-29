#!/usr/bin/env bash
source "$(dirname "$0")/00-common.sh"

log "docker"
if have docker; then
    $SUDO systemctl enable --now docker || warn "docker non parte"
    if ! id -nG "$TARGET_USER" | grep -qw docker; then
        $SUDO usermod -aG docker "$TARGET_USER"
        warn "utente aggiunto al gruppo docker: serve un nuovo login"
    fi
else
    warn "docker non installato"
fi

log "tailscale"
if have tailscale; then
    $SUDO systemctl enable --now tailscaled || warn "tailscaled non parte"
    $SUDO tailscale status >/dev/null 2>&1 || $SUDO tailscale up || warn "rilancia: sudo tailscale up"
else
    warn "tailscale non installato"
fi

log "estensioni vscode"
if have code && [ -s "$REPO_DIR/packages/vscode-extensions.txt" ]; then
    xargs -r -n1 code --install-extension < "$REPO_DIR/packages/vscode-extensions.txt" || warn "qualche estensione non installata"
fi

log "mise"
if have mise && [ -f "$HOME/.config/mise/config.toml" ]; then
    mise install || warn "mise install non completato"
fi

cat <<'EOF'

Resta da fare a mano:
  - Nextcloud: login e le due cartelle (~/projects, ~/Documents)
  - Android Studio: riscarica l'SDK
  - profili Flatpak: Zen, Telegram, Prism/Minecraft
  - Bitwarden: verifica le voci "restic laptop" e "restic"
EOF
