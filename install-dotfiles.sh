#!/bin/bash
echo "Inizio ripristino del sistema immacolato..."

# 1. Installa i pacchetti
echo "Installazione app..."
sudo dnf install -y $(cat packages/dnf-packages.txt)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub $(cat packages/flatpaks.txt)

# 2. Ripristina i file
echo "Copia dei file di configurazione..."
cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh
cp .gitconfig ~/.gitconfig
cp -r config/* ~/.config/

# 3. Ripristina GNOME
echo "Ripristino impostazioni GNOME..."
dconf load / < gnome/gnome-settings.ini

echo "Finito! Riavvia il PC per applicare tutte le modifiche visive."