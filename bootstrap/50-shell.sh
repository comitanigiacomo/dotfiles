#!/usr/bin/env bash
# Zsh + oh-my-zsh + tema powerlevel10k + plugin + font.
source "$(dirname "$0")/00-common.sh"

log "Shell"
$SUDO dnf -y install zsh git curl

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    warn "oh-my-zsh gia' presente"
fi

clone_if_missing() {  # url, destinazione
    if [ ! -d "$2" ]; then
        git clone --depth=1 "$1" "$2"
    else
        warn "gia' presente: $2"
    fi
}

clone_if_missing https://github.com/romkatv/powerlevel10k.git \
    "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions \
    "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

# Font (MesloLGS NF) ripristinati in ~/.local/share/fonts
if [ -d "$HOME/.local/share/fonts" ]; then
    fc-cache -f "$HOME/.local/share/fonts" >/dev/null 2>&1 || true
fi

# Shell di login
if [ "$SHELL" != "$(command -v zsh)" ]; then
    $SUDO chsh -s "$(command -v zsh)" "$TARGET_USER"
fi

log "Shell pronta (riapri la sessione per usarla)"
