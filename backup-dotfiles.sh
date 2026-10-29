#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

cp ~/.zshrc ~/.p10k.zsh ~/.gitconfig ./

mkdir -p config/Code/User
cp ~/.config/Code/User/settings.json config/Code/User/ 2>/dev/null || true
cp ~/.config/Code/User/keybindings.json config/Code/User/ 2>/dev/null || true
for d in nvim alacritty btop; do
    if [ -d "$HOME/.config/$d" ]; then
        cp -r "$HOME/.config/$d" config/
    fi
done

mkdir -p gnome
dconf dump / > gnome/gnome-settings.ini

mkdir -p packages
dnf repoquery --userinstalled --qf '%{name}\n' 2>/dev/null | sort -u > packages/dnf-packages.txt || true
dnf repolist --enabled 2>/dev/null | awk 'NR>1 && NF {print $1}' | sort -u > packages/dnf-repos.txt || true
flatpak list --app --columns=application > packages/flatpaks.txt || true
flatpak list --runtime --columns=application,branch 2>/dev/null | sort -u > packages/flatpak-runtimes.txt || true
gnome-extensions list --enabled 2>/dev/null > packages/gnome-extensions.txt || true
command -v code >/dev/null && code --list-extensions > packages/vscode-extensions.txt 2>/dev/null || true

git add -A
if git diff --cached --quiet; then
    echo "niente da salvare"
else
    git commit -m "dotfiles $(date +%F)"
    echo "commit fatto, poi: git push"
fi
