# Fedora Dotfiles

Personal configuration files and automation scripts for Fedora Workstation (GNOME).

## Environment
- **OS**: Fedora Workstation
- **Shell**: Zsh (Oh-My-Zsh, Powerlevel10k)
- **Editor**: VS Code, Neovim
- **Desktop**: GNOME (Pop-shell, Tiling-assistant)

## Installation

To restore this configuration on a fresh Fedora installation:

```bash
mkdir -p ~/projects
git clone https://github.com/comitanigiacomo/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
chmod +x install-dotfiles.sh
./install-dotfiles.sh
```

Reboot the system after the script completes to apply GNOME settings.

## Updating

To sync current local configurations back to this repository:

```bash
cd ~/projects/dotfiles
./backup-dotfiles.sh
git add .
git commit -m "Update configs"
git push
```