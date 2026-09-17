#!/bin/bash
echo "Raccolta dei dotfiles in corso..."

# 1. Copia i file della Shell
cp ~/.zshrc ./
cp ~/.p10k.zsh ./
cp ~/.gitconfig ./

# 2. Copia i file dei Programmi
mkdir -p config/Code/User
cp ~/.config/Code/User/settings.json config/Code/User/ 2>/dev/null
cp ~/.config/Code/User/keybindings.json config/Code/User/ 2>/dev/null
cp -r ~/.config/nvim config/ 2>/dev/null
cp -r ~/.config/alacritty config/ 2>/dev/null
cp -r ~/.config/btop config/ 2>/dev/null

# 3. Salva le impostazioni di GNOME e le estensioni in un file di testo!
mkdir -p gnome
dconf dump / > gnome/gnome-settings.ini
echo "Impostazioni GNOME esportate."

# 4. Salva la lista dei software
mkdir -p packages
dnf repoquery --userinstalled --queryformat "%{name}" > packages/dnf-packages.txt
flatpak list --app --columns=application > packages/flatpaks.txt
echo "Lista pacchetti salvata."

echo "Backup locale completato"