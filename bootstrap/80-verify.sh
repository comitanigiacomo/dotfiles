#!/usr/bin/env bash
source "$(dirname "$0")/00-common.sh"

FAIL=0
check() {
    if eval "$2" >/dev/null 2>&1; then
        echo "  ok   $1"
    else
        echo "  no   $1"
        FAIL=$((FAIL + 1))
    fi
}

log "verifica"

check "zsh"                  "have zsh"
check "oh-my-zsh"            "[ -d $HOME/.oh-my-zsh ]"
check "powerlevel10k"        "[ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]"
check "zsh-autosuggestions"  "[ -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]"
check "zsh-syntax"           "[ -d $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]"
check ".zshrc"               "[ -f $HOME/.zshrc ]"
check "chiave ssh"           "[ -f $HOME/.ssh/id_ed25519 ]"
check "code"                 "have code"
check "docker"               "have docker"
check "tailscale"            "have tailscale"
check "restic"               "have restic"
check "mise"                 "have mise"
check "java"                 "have java"
check "projects"             "[ -d $HOME/projects ]"
check "Documents"            "[ -d $HOME/Documents ]"
check "flatpak"              "[ \$(flatpak list --app | wc -l) -ge 10 ]"
check "estensioni gnome"     "[ \$(gnome-extensions list --enabled 2>/dev/null | wc -l) -ge 3 ]"

echo
[ "$FAIL" -eq 0 ] && log "tutto a posto" || warn "$FAIL controlli falliti"
