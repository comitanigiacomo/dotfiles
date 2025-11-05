# 💫 I Miei Dotfiles Hyprland

Benvenuti nella mia configurazione personale di Hyprland, gestita con GNU Stow.

---

### Stack Tecnologico

| Categoria | Software |
| :--- | :--- |
| **Window Manager** | Hyprland |
| **Terminale** | Kitty |
| **Shell** | Zsh (con Oh My Zsh e p10k) |
| **Editor** | Neovim |
| **Notifiche** | SwayNC |
| **Gestore Dotfiles** | GNU Stow |

---

### Installazione

1.  Clona il repository:
    ```bash
    git clone [https://github.com/comitanigiacomo/dotfiles.git](https://github.com/comitanigiacomo/dotfiles.git) ~/dotfiles
    ```

2.  Entra nella cartella:
    ```bash
    cd ~/dotfiles
    ```

3.  Applica le configurazioni con Stow:
    ```bash
    # Applica tutto
    stow *

    # O applica solo quelli scelti
    stow zsh
    stow hypr
    stow nvim
    stow kitty
    stow swaync
    stow tmux
    ```