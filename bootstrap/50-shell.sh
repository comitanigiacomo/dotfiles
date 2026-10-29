#!/usr/bin/env bash
source "$(dirname "$0")/00-common.sh"

log "shell"
$SUDO dnf -y install zsh git curl

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

clone() {
    [ -d "$2" ] || git clone --depth=1 "$1" "$2"
}

clone https://github.com/romkatv/powerlevel10k.git \
    "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions \
    "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

if [ -d "$HOME/.local/share/fonts" ]; then
    fc-cache -f "$HOME/.local/share/fonts" >/dev/null 2>&1
fi

[ "$SHELL" = "$(command -v zsh)" ] || $SUDO chsh -s "$(command -v zsh)" "$TARGET_USER"
