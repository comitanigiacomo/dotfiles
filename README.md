# I Miei Dotfiles per Hyprland (Ambiente Minimalista)

Questa repository contiene la mia configurazione personale per **Hyprland**, pulita e pronta per essere replicata su una nuova installazione Linux. Ho rimosso tutti i file di backup, di stato e i profili alternativi per mantenere solo l'essenziale.

![Immagine di anteprima del mio desktop](https://[INSERISCI QUI IL LINK AL TUO SCREENSHOT])

---

## 📦 Dipendenze Essenziali

**ATTENZIONE:** Prima di procedere con `stow`, è fondamentale installare tutti i pacchetti elencati di seguito. `stow` gestisce solo le configurazioni, non installa il software.

### Pacchetti di Sistema (Software)
| Programma | Pacchetti Richiesti | Note |
| :--- | :--- | :--- |
| **Compositor/Core** | `hyprland`, `hyprlock`, `hypridle` | Base del sistema. |
| **Interfaccia** | `waybar`, `rofi` (o `rofi-wayland`), `swaync` | Barra, Launcher e Notifiche. |
| **Terminal/Shell** | `kitty`, `zsh`, `neovim` | Terminale, Shell e Editor di codice. |
| **Strumenti** | `stow`, `jq`, `pamixer`, `playerctl`, `brightnessctl`, `grim`, `slurp`, `swappy` | Utilità essenziali per gli script. |

### 🎨 Estetica (Critico per il Look)
| Elemento | Nome Esatto | Istruzioni |
| :--- | :--- | :--- |
| **Terminal Font** | `FantasqueSansM Nerd Font Mono Bold` | Da installare nel sistema. |
| **UI/Icon Font** | `JetBrainsMono Nerd Font` | Essenziale per le icone di Waybar/Rofi. |
| **Tema GTK/Icone** | `Adwaita` (forzato scuro) | Utilizza il tema di default di GNOME. |

---

## 🛠️ Istruzioni di Installazione

Per sincronizzare il sistema, cloniamo il repository e usiamo `stow`.

### Passo 1: Clonazione e Setup

```bash
# 1. Clona il repository nella cartella dotfiles
git clone [https://github.com/](https://github.com/)[IL TUO NOME UTENTE]/[NOME REPO].git ~/dotfiles

# 2. Vai nella cartella
cd ~/dotfiles

### Passo 2: Sincronizzazione Completa con stow

Esegui i comandi esattamente come sono stati testati e che hanno risolto tutti i conflitti.

A. Collega Configurazione (.config):

```bash

# Collega tutte le cartelle principali (hypr, rofi, waybar, GTK, ecc.)
stow -t ~/.config hypr kitty nvim rofi swaync waybar gtk-3.0 gtk-4.0

```
B. Collega Shell (Zsh):

```bash

# Collega il file .zshrc
stow -t ~ zsh

```

### Passo 3: Finalizzazione

    Imposta la Shell: chsh -s /usr/bin/zsh

    Riavvia: Esegui un logout/login per caricare il nuovo ambiente.

