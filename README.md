# Hyprland Dotfiles

This repository contains my personal configuration files for the **Hyprland** Wayland compositor. The setup includes custom themes for Waybar, Rofi, Kitty, and Zsh (with Powerlevel10k).

This configuration was born from the desire to create an environment that is clean, highly **functional**, and aesthetically pleasing. The choice of **Hyprland** was primarily driven by its ability to offer sophisticated graphical features, like the  **transparency (blur and opacity)**

***Crucially, the main objective behind this project was to create a configuration that could be easily and reliably recreated on another machine in case of necessity***.

## Target System (Base Installation)

> [!CAUTION]
> This configuration is designed to be applied on top of a minimal, functioning Hyprland installation.

The script does not install Hyprland itself, Wayland, or a display manager (like SDDM or Greetd). It assumes you are starting from an OS (like Arch Linux, Fedora, etc.) where you can already log in to a base Hyprland session.

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
| `stow` | The core tool used to manage and symlink all configuration files. |
| `git` | For cloning this repository. |
| `unzip` | Extraction utility. |
| `curl` | Necessary for installing Oh My Zsh. |
| `fzf` | Command-line fuzzy finder (for Zsh bindings). |
| `lsd` | Modern replacement for `ls` (for terminal file listings). |

### Installation

The `install.sh` script automates the entire setup process. It is designed to be safe and robust, performing three main actions:

1.  **Backs Up:** Automatically finds existing configurations (like `~/.config/hypr`, `~/.zshrc`, etc.) and moves them to a dated backup folder (`~/.config_backup_...`).
2.  **Installs Dependencies:** Installs external plugins like Oh My Zsh and its required plugins.
3.  **Symlinks (Stow):** Uses `stow` to create symlinks for **all** configuration packages in this repository, linking them to their correct locations on the system.

> [!CAUTION]
> This script will **move** any existing configurations it finds to a backup directory. It does **not** copy files; it creates **symlinks**. This means any change you make to a config file (e.g., `~/.config/hypr/hyprland.conf`) will instantly modify the file within this `dotfiles` repository.

#### Step 1: Clone the Repository

Open a terminal and clone the repository into your `Home` directory:

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

The script will guide you through the process. When prompted, enter your user password for the final `chsh` command (to set Zsh as your default shell).

#### Step 3: Finalization (Login)

Once the script finishes, Log out of your current session and Log in again. This is necessary for all changes (especially the zsh shell and new system fonts) to take effect

## Repository Structure

This repository uses `stow` to manage packages. Each directory is a "package" that contains the configuration files nested in the path they will be linked to.

| Package | Target Directory | Description |
| :--- | :--- | :--- |
| **`hypr`** | `~/.config/hypr` | Contains the main Hyprland configuration files (`hyprland.conf`), keybinds, window rules, etc. |
| **`waybar`** | `~/.config/waybar` | Configurations (CSS and JSON) for the Waybar status bar. |
| **`rofi`** | `~/.config/rofi` | Themes and configurations for Rofi, the application launcher. |
| **`kitty`** | `~/.config/kitty` | Configuration files for the Kitty terminal emulator. |
| **`zsh`** | `~/` | Contains the `.zshrc` file and Powerlevel10k prompt settings. |
| **`swaync`** | `~/.config/swaync` | Configuration for the Sway Notification Center. |
| **`wlogout`** | `~/.config/wlogout` | CSS and layout files for the wlogout power menu. |
| **`wallust`** | `~/.config/wallust` | Templates for Wallust (wallpaper color generator). Also provides themes for other apps. |
| **`gtk-3.0`** | `~/.config/gtk-3.0` | Configuration files for the look of GTK3 applications. |
| **`gtk-4.0`** | `~/.config/gtk-4.0` | Configuration files for the look of GTK4 applications. |
| **`wallpapers`** | `~/Pictures/Wallpapers` | Wallpaper files managed by `swww`. |
| **`images`** | `~/Pictures` | Static images (like screenshots) used in this README. |
| **`fonts`** | `~/.local/share/fonts` | Custom fonts (Nerd Fonts) essential for icons. |
| **`nvim`** | `~/.config/nvim` | Configuration for NeoVim. |
| **`install.sh`** | (N/A) | The **main installation script**. It automates backups, plugin installation, and symlinking all packages via `stow`. |

![alt text](images/Pictures/image-1.png)

![alt text](images/Pictures/image-2.png)

![alt text](images/Pictures/image-3.png)

### Credits 

This configuration is heavily inspired by and uses structure elements from [JaKooLit's Hyprland dotfiles](https://github.com/JaKooLit/Hyprland-Dots), which served as an excellent functional base for this project.