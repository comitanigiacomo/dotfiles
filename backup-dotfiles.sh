#!/usr/bin/env bash
# Raccoglie dotfiles e liste pacchetti nel repo, poi commit.
set -euo pipefail
cd "$(dirname "$0")"

echo "Raccolta dei dotfiles in corso..."

# 1. Shell
cp ~/.zshrc ./
cp ~/.p10k.zsh ./
cp ~/.gitconfig ./

# 2. Programmi
mkdir -p config/Code/User
cp ~/.config/Code/User/settings.json config/Code/User/ 2>/dev/null || true
cp ~/.config/Code/User/keybindings.json config/Code/User/ 2>/dev/null || true
for d in nvim alacritty btop; do
    [ -d "$HOME/.config/$d" ] && cp -r "$HOME/.config/$d" config/
done

# 3. GNOME
mkdir -p gnome
dconf dump / > gnome/gnome-settings.ini

# 4. Liste software
mkdir -p packages
dnf repoquery --userinstalled --qf '%{name}\n' 2>/dev/null | sort -u > packages/dnf-packages.txt || true
dnf repolist --enabled --qf '%{repoid}\n' 2>/dev/null | sort -u > packages/dnf-repos.txt || true
flatpak list --app --columns=application > packages/flatpaks.txt || true
flatpak list --runtime --columns=application,branch 2>/dev/null | sort -u > packages/flatpak-runtimes.txt || true
gnome-extensions list --enabled 2>/dev/null > packages/gnome-extensions.txt || true
command -v code >/dev/null && code --list-extensions > packages/vscode-extensions.txt 2>/dev/null || true

# 5. Commit (il push lo fai tu)
if git rev-parse --git-dir >/dev/null 2>&1; then
    git add -A
    if git diff --cached --quiet; then
        echo "Nessuna modifica da salvare."
    else
        git commit -m "backup dotfiles $(date +%F)"
        echo "Commit creato. Verifica e poi: git push"
    fi
fi

printf '\nBackup locale completato.\n'
