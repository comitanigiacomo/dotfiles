#!/bin/bash

# --- Variabili Globali ---
DOTFILES_DIR=$HOME/dotfiles
BACKUP_DIR=$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)

STOW_PACKAGES="fonts gtk-3.0 gtk-4.0 hypr images kitty nvim rofi swaync wallust wallpapers waybar wlogout zsh"

# --- Funzione di Backup ---
backup() {
    local target=$1
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "-> Backup di $target..."
        mv "$target" "$BACKUP_DIR/"
    fi
}

# --- Inizio Script ---
echo "Avvio installazione dotfiles..."

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "ERRORE: La cartella dotfiles non si trova in $DOTFILES_DIR."
    exit 1
fi

if ! command -v stow &> /dev/null; then
    echo "ERRORE: 'stow' non è installato. Per favore installalo prima di continuare."
    exit 1
fi

# --- 1. Fase di Backup ---
echo "--- Fase 1: Backup delle configurazioni esistenti ---"
mkdir -p "$BACKUP_DIR"
echo "Le vecchie configurazioni (se trovate) verranno spostate in: $BACKUP_DIR"

# Backup dei target principali che creano conflitti con 'stow'
backup "$HOME/.config/hypr"
backup "$HOME/.config/kitty"
backup "$HOME/.config/nvim"
backup "$HOME/.config/waybar"
backup "$HOME/.config/rofi"
backup "$HOME/.config/swaync"
backup "$HOME/.config/wlogout"
backup "$HOME/.config/wallust"
backup "$HOME/.config/gtk-3.0"
backup "$HOME/.config/gtk-4.0"
backup "$HOME/.local/share/fonts"
backup "$HOME/Pictures"           
backup "$HOME/.zshrc"
backup "$HOME/.p10k.zsh"
backup "$HOME/.oh-my-zsh"

echo "Backup completato."

# --- 2. Fase Plugin (Oh My Zsh) ---
echo "--- Fase 2: Installazione Plugin Esterni ---"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installazione Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/oh-my-zsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh già installato, skip."
fi

echo "Installazione Zsh Plugins (syntax, p10k, autosuggestions)..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting || echo "Plugin syntax-highlighting già presente."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k || echo "Plugin powerlevel10k già presente."
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions || echo "Plugin autosuggestions già presente."

echo "Rimozione del file .zshrc generato da Oh My Zsh (per fare spazio al nostro)..."
rm -f "$HOME/.zshrc"

# --- 3. Fase di Linking (Stow) ---
echo "--- Fase 3: Creazione Link Simbolici (Stow) ---"
echo "Applicazione di tutti i pacchetti: $STOW_PACKAGES"

cd "$DOTFILES_DIR"
stow -S $STOW_PACKAGES

if [ $? -ne 0 ]; then
    echo "ERRORE: Il comando 'stow' è fallito."
    echo "Possibile causa: conflitti non risolti (file già esistenti)."
    echo "Controlla i file in $BACKUP_DIR e rimuovi i conflitti manualmente."
    exit 1
fi

echo "Link simbolici creati con successo."

# --- 4. Fase di Post-Installazione ---
echo "--- Fase 4: Post-Installazione ---"

# 4.1. Correzione Permessi Script
echo "Impostazione permessi per gli script (ora linkati)..."
chmod +x "$HOME"/.config/hypr/scripts/*
chmod +x "$HOME"/.config/hypr/UserScripts/*
chmod +x "$HOME"/.config/hypr/initial-boot.sh

# 4.2. Ricostruisce la cache dei font (FC-CACHE)
echo "Ricostruzione della cache dei font (fc-cache)..."
fc-cache -f -v

# 4.3. Imposta Zsh come shell di default
if [ -f /usr/bin/zsh ]; then
    echo "---"
    echo "ATTENZIONE: Lo script ora tenterà di impostare Zsh come shell di default."
    echo "Inserisci la password di '$USER' (la tua password di login) quando richiesta."
    echo "---"
    chsh -s /usr/bin/zsh
    if [ $? -ne 0 ]; then
        echo "ERRORE: Cambio shell fallito. Eseguilo manualmente: chsh -s /usr/bin/zsh"
    fi
else
    echo "ATTENZIONE: /usr/bin/zsh non trovato."
fi

echo -e "\n--- INSTALLAZIONE COMPLETATA ---"
echo "Per favore, fai Logout e Login per applicare tutte le modifiche (inclusa la shell Zsh)."