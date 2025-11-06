#!/bin/bash

# --- Variabili di Sistema ---
DOTFILES_DIR=$HOME/dotfiles
CONFIG_DIR=$HOME/.config
STOW_PACKAGES="kitty nvim rofi swaync waybar gtk-3.0 gtk-4.0"

# --- 1. Controllo Essenziale ---
if ! command -v stow &> /dev/null; then
    echo "Errore: 'stow' non è installato. Installalo prima di procedere (es. sudo pacman -S stow)."
    exit 1
fi
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Errore: La cartella dotfiles non si trova in $DOTFILES_DIR."
    exit 1
fi

echo "--- 🧹 Fase 1: Pulizia dei Conflitti ---"
# Rimuove le cartelle locali e i link simbolici esistenti che interferiscono con STOW.
# Questo previene l'errore 'existing target is not owned'.

function clean_config {
    echo "Pulizia $1..."
    rm -rf "$CONFIG_DIR/$1"
}

# Pulizia di tutte le cartelle che verranno gestite da stow
for pkg in hypr $STOW_PACKAGES; do
    clean_config "$pkg"
done
# Pulizia file zsh
rm -f "$HOME/.zshrc"

echo "Pulizia completata. Le destinazioni sono pronte."

echo -e "\n--- 🛠️ Fase 2: Installazione con STOW ---"

# 2.1. Installazione Hyprland (La Struttura Complessa)
echo "Installazione Hyprland (Struttura annidata)..."
stow -t "$CONFIG_DIR" --dir hypr/.config hypr
if [ $? -ne 0 ]; then
    echo "ERRORE: Installazione Hyprland fallita. Controlla la struttura di hypr/.config/hypr."
    exit 1
fi

# 2.2. Installazione Pacchetti con Struttura Piatta
echo "Installazione Pacchetti Standard (Kitty, Rofi, Waybar, etc.)..."
stow -t "$CONFIG_DIR" $STOW_PACKAGES
stow -t "$HOME" zsh

# 2.3. Risoluzione Manuale (GTK Settings)
# Questi link sono stati creati a mano perché stow ha dato problemi, ma sono essenziali.
echo "Correzione link GTK settings..."
ln -s "$DOTFILES_DIR/gtk-3.0/settings.ini" "$CONFIG_DIR/gtk-3.0/settings.ini"
ln -s "$DOTFILES_DIR/gtk-4.0/settings.ini" "$CONFIG_DIR/gtk-4.0/settings.ini"

echo -e "\n--- 🚀 Fase 3: Post-Installazione e Permessi ---"

# 3.1. Installazione Zsh Plugin (Oh My Zsh non gestito da stow)
echo "Installazione Zsh Plugins e Framework..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 3.2. Correzione Permessi Script
# La tua configurazione Hyprland fallisce se gli script non sono eseguibili
echo "Impostazione permessi per gli script..."
chmod +x "$CONFIG_DIR"/hypr/scripts/*
chmod +x "$CONFIG_DIR"/hypr/UserScripts/*
chmod +x "$CONFIG_DIR"/hypr/initial-boot.sh

echo -e "\n✅ Installazione completata! Verificare l'ambiente:"
echo "   1. Riavvia la sessione (Logout e Login)."
echo "   2. Controlla che Hyprland, Waybar e Rofi siano caricati correttamente."

# fine dello script