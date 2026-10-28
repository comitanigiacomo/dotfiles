#!/usr/bin/env bash
# Controlla che il ripristino sia completo.
source "$(dirname "$0")/00-common.sh"

FAIL=0
check() {  # descrizione, comando
    if eval "$2" >/dev/null 2>&1; then
        printf '  [ok]   %s\n' "$1"
    else
        printf '  [NO]   %s\n' "$1"
        FAIL=$((FAIL + 1))
    fi
}

log "Verifica installazione"

check "shell zsh"            "have zsh"
check "oh-my-zsh"            "[ -d $HOME/.oh-my-zsh ]"
check "tema powerlevel10k"   "[ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]"
check "plugin autosuggestions" "[ -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]"
check "plugin syntax-highlighting" "[ -d $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]"
check "dotfiles (.zshrc)"    "[ -f $HOME/.zshrc ]"
check "chiave SSH"           "[ -f $HOME/.ssh/id_ed25519 ]"
check "VS Code"              "have code"
check "Docker"               "have docker"
check "Tailscale"            "have tailscale"
check "restic"               "have restic"
check "mise"                 "have mise"
check "java"                 "have java"
check "progetti"             "[ -d $HOME/projects ]"
check "documenti"            "[ -d $HOME/Documents ]"
check "Flatpak installati"   "[ \$(flatpak list --app | wc -l) -ge 10 ]"
check "estensioni GNOME"     "[ \$(gnome-extensions list --enabled 2>/dev/null | wc -l) -ge 3 ]"

echo
if [ "$FAIL" -eq 0 ]; then
    log "Tutto a posto"
else
    warn "$FAIL controlli falliti: guarda sopra e completa a mano"
fi
