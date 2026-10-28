#!/usr/bin/env bash
# Ripristina il sistema a partire da questo repo (Fedora Workstation).
set -euo pipefail
cd "$(dirname "$0")"

echo "Inizio ripristino..."

# 1. Repository (rpmfusion, vscode, chrome, tailscale, copr...) vanno riaggiunti a mano
#    se packages/dnf-repos.txt contiene repo non ufficiali.

# 2. Pacchetti
if [ -s packages/dnf-packages.txt ]; then
    echo "Installazione pacchetti rpm..."
    sudo dnf install -y --skip-unavailable $(cat packages/dnf-packages.txt) || \
        echo "ATTENZIONE: alcuni pacchetti non sono disponibili (repo mancanti?), vedi sopra."
else
    echo "packages/dnf-packages.txt vuoto: salto."
fi

# 3. Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
if [ -s packages/flatpaks.txt ]; then
    echo "Installazione Flatpak..."
    xargs -r flatpak install -y --noninteractive flathub < packages/flatpaks.txt || true
fi

# 4. File di configurazione
cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh
cp .gitconfig ~/.gitconfig
cp -r config/* ~/.config/

# 5. GNOME
if [ -f gnome/gnome-settings.ini ]; then
    dconf load / < gnome/gnome-settings.ini
fi

# 6. Estensioni e VS Code
if [ -s packages/gnome-extensions.txt ]; then
    while read -r ext; do
        gnome-extensions enable "$ext" 2>/dev/null || true
    done < packages/gnome-extensions.txt
fi
if [ -s packages/vscode-extensions.txt ] && command -v code >/dev/null; then
    xargs -r -n1 code --install-extension < packages/vscode-extensions.txt || true
fi

echo "Finito. Riavvia la sessione per applicare tutto."
