#!/usr/bin/env bash
source "$(dirname "$0")/00-common.sh"

SSH_HOST="server"
SSH_TARGET="jack-server"
SSH_IP="100.90.133.13"
RESTIC_REMOTE="/home/jack-server/backups/restic-laptop"

[ "$(id -un)" = "jack" ] || die "serve l'utente jack: il backup contiene /home/jack"
[ "$(id -u)" -eq 0 ] && die "non eseguire come root"

have restic || $SUDO dnf -y install restic
have restic || die "restic non disponibile"

mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
if ! grep -qs "Host $SSH_HOST" "$HOME/.ssh/config"; then
    printf 'Host %s\n    HostName %s\n    User %s\n' "$SSH_HOST" "$SSH_IP" "$SSH_TARGET" >> "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
fi

[ -f "$HOME/.ssh/id_ed25519" ] || ssh-keygen -t ed25519 -N '' -C "$(id -un)@$(hostname)" -f "$HOME/.ssh/id_ed25519"

if ! ssh -o BatchMode=yes -o ConnectTimeout=10 "$SSH_HOST" true 2>/dev/null; then
    warn "autorizzo la chiave sul server (password di $SSH_TARGET)"
    ssh-copy-id -i "$HOME/.ssh/id_ed25519.pub" "$SSH_HOST"
fi
ssh -o BatchMode=yes -o ConnectTimeout=10 "$SSH_HOST" true || die "ssh $SSH_HOST non funziona"

export RESTIC_REPOSITORY="sftp:${SSH_HOST}:${RESTIC_REMOTE}"

if [ -z "${RESTIC_PASSWORD:-}" ]; then
    read -rsp "password restic (Bitwarden: restic laptop): " RESTIC_PASSWORD
    echo
fi
export RESTIC_PASSWORD

restic cat config >/dev/null || die "repository o password non validi"

log "ripristino l'ultimo snapshot in $HOME"
restic restore latest --target / --verify

if [ -d "$HOME/.config/backup" ]; then
    printf '%s' "$RESTIC_PASSWORD" > "$HOME/.config/backup/restic-password"
    chmod 600 "$HOME/.config/backup/restic-password"
fi

warn "riapri la sessione: shell e chiavi sono quelle del backup"
warn "backup manuale: lancia 'backup-now' una volta al mese"
