#!/usr/bin/env bash
# Ripristina la home dall'ultimo snapshot restic sul server.
source "$(dirname "$0")/00-common.sh"

SSH_HOST="server"
SSH_TARGET="jack-server"
SSH_IP="100.90.133.13"
RESTIC_REMOTE="/home/jack-server/backups/restic-laptop"

log "Preparo l'accesso al server"

# Lo snapshot contiene /home/jack: su un PC nuovo l'utente deve chiamarsi jack.
if [ "$(id -un)" != "jack" ]; then
    die "Lo snapshot usa /home/jack. Crea l'utente 'jack' oppure ripristina a mano con --target."
fi
[ "$(id -u)" -eq 0 ] && die "Non eseguire come root: serve l'utente jack."

command -v restic >/dev/null || $SUDO dnf -y install restic
have restic || die "restic non disponibile"

mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
if ! grep -qs "Host $SSH_HOST" "$HOME/.ssh/config"; then
    cat >> "$HOME/.ssh/config" <<EOF
Host $SSH_HOST
    HostName $SSH_IP
    User $SSH_TARGET
EOF
    chmod 600 "$HOME/.ssh/config"
fi

# Chiave temporanea solo per raggiungere il server: verra' sostituita dal restore.
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-keygen -t ed25519 -N '' -C "$(id -un)@$(hostname)" -f "$HOME/.ssh/id_ed25519"
fi

if ! ssh -o BatchMode=yes -o ConnectTimeout=10 "$SSH_HOST" true 2>/dev/null; then
    warn "La chiave non e' ancora autorizzata sul server."
    warn "Inserisci la password di $SSH_TARGET quando richiesto:"
    ssh-copy-id -i "$HOME/.ssh/id_ed25519.pub" "$SSH_HOST"
fi
ssh -o BatchMode=yes -o ConnectTimeout=10 "$SSH_HOST" true || die "SSH verso '$SSH_HOST' non funziona"

export RESTIC_REPOSITORY="sftp:${SSH_HOST}:${RESTIC_REMOTE}"

if [ -z "${RESTIC_PASSWORD:-}" ]; then
    read -rsp "Password restic (Bitwarden: 'restic laptop'): " RESTIC_PASSWORD
    echo
fi
export RESTIC_PASSWORD

log "Verifico il repository"
restic cat config >/dev/null || die "Repository o password non validi"

log "Ripristino l'ultimo snapshot in $HOME"
warn "I file gia' presenti con lo stesso nome verranno sovrascritti."
restic restore latest --target / --verify

log "Home ripristinata"

# Il file password e' volutamente escluso dal backup: lo ricreo ora
# cosi' il comando 'backup-now' funziona subito su questo PC.
if [ -d "$HOME/.config/backup" ]; then
    printf '%s' "$RESTIC_PASSWORD" > "$HOME/.config/backup/restic-password"
    chmod 600 "$HOME/.config/backup/restic-password"
    log "Password salvata in ~/.config/backup/restic-password"
fi

warn "Riapri la sessione: shell, chiavi e configurazioni sono quelle del backup."
warn "Backup: non ci sono timer. Lancialo a mano con 'backup-now' (una volta al mese)."
