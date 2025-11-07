# Hyprland Dotfiles

This repository contains my personal configuration files for the **Hyprland** Wayland compositor, tailored for Fedora/Arch Linux distributions. The setup includes custom themes for Waybar, Rofi, Kitty, and Zsh (with Powerlevel10k).

The installation is designed to run successfully on a **clean base system of hyperland**

## Prerequisites

Before cloning or running the script, it is crucial that the following base packages are installed on the system.

### 1. Essential Packages (System-wide Installation)

These core programs and utilities must be installed :

| Package | Description |
| :--- | :--- |
| `hyprland` | The main Wayland Window Manager. |
| `waybar` | The custom status bar. |
| `kitty` | The terminal emulator used in the setup. |
| `rofi` | The application launcher. |
| `swww` | The wallpaper manager (for animated and static backgrounds). |
| `wlogout` | The graphical power/logout menu. |
| `swaync` | The Wayland notification center. |
| `wallust` | The wallpaper-based color scheme generator. |
| `zsh` | The advanced shell. |
| `stow` | The tool used for managing dotfile symlinks. |
| `git` | For cloning this repository. |
| `unzip` | Extraction utility. |
| `curl` | Necessary for installing Oh My Zsh. |
| `fzf` | Command-line fuzzy finder (for Zsh bindings). |
| `lsd` | Modern replacement for `ls` (for terminal file listings). |

### Installation

The provided `install.sh` script automates file copying, plugin installation, permission setting, and shell configuration.

#important[ The script will require your user password for the final `chsh` command (Change Shell).]

#### Step 1: Clone the Repository

Open a terminal and clone the repository into your Home directory:

```bash
git clone git@github.com:comitanigiacomo/dotfiles.git
```

#### Step 2: Run the Script

Navigate into the directory, and run the scrypt:

```bash
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

#### Step 3: Finalization (Login)

- When prompted, enter your user password for the final `chsh` command (Change Shell).

- Once the script finishes, Log Out of your current session (hyprctl dispatch exit or similar).

- Log In again, making sure to select the Hyprland session

