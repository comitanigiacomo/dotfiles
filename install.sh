#!/bin/bash

# --- Variabili di Sistema ---
DOTFILES_DIR=$HOME/dotfiles
CONFIG_DIR=$HOME/.config

# --- Elenco Pacchetti Personalizzato (Basato sulla TUA Struttura) ---
# Pacchetti "Piatti" (gestiti da COPIA)
PACKAGES_FLAT="rofi gtk-3.0 gtk-4.0 wallust"

# Pacchetti "Annidati" (gestiti da COPIA MANUALE)
PACKAGES_NESTED="hypr kitty nvim swaync waybar"

# Pacchetti "Home" (gestiti da STOW)
PACKAGES_HOME="zsh"

# --- 1. Controllo Essenziale ---
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Errore: La cartella dotfiles non si trova in $DOTFILES_DIR."
    exit 1
fi
if ! command -v stow &> /dev/null; then
    echo "Errore: 'stow' non è installato (serve per Zsh)."
    exit 1
fi

echo "--- 🧹 Fase 1: Pulizia dei Conflitti (Definitiva) ---"
# Rimuove le cartelle locali E i file di conflitto

function clean_config {
    echo "Pulizia $1..."
    rm -rf "$CONFIG_DIR/$1"
}

# Pulizia di tutte le cartelle che verranno gestite
for pkg in $PACKAGES_FLAT; do
    clean_config "$pkg"
done
for pkg in $PACKAGES_NESTED; do
    clean_config "$pkg"
done
rm -rf "$HOME/Pictures/wallpapers" # Pulizia V21

# Pulizia Zsh (INCLUSO .p10k.zsh e .oh-my-zsh che causavano i conflitti)
echo "Pulizia file Zsh..."
rm -f "$HOME/.zshrc"
rm -f "$HOME/.p10k.zsh"
rm -rf "$HOME/.oh-my-zsh"

echo "Pulizia completata. Le destinazioni sono pronte."

echo -e "\n--- 🛠️ Fase 2: Installazione (Metodo Copia Manuale) ---"

# 2.1. Installazione Pacchetti Annidati (COPIA MANUALE)
echo "Installazione Pacchetti Annidati (Copia Manuale: Hypr, Kitty, Waybar...)"
for pkg in $PACKAGES_NESTED; do
    echo "-> Copiando (annidato) $pkg"
    mkdir -p "$CONFIG_DIR/$pkg"
    cp -r "$DOTFILES_DIR/$pkg"/.config/"$pkg"/* "$CONFIG_DIR/$pkg/"
done

# 2.2. Installazione Pacchetti Piatti (COPIA MANUALE)
echo "Installazione Pacchetti Piatti (Copia Manuale: Rofi, Wallust, GTK...)"
for pkg in $PACKAGES_FLAT; do
    echo "-> Copiando (piatto) $pkg"
    mkdir -p "$CONFIG_DIR/$pkg"
    cp -r "$DOTFILES_DIR/$pkg"/* "$CONFIG_DIR/$pkg/"
done

# 2.3. Installazione Sfondi (COPIA MANUALE)
echo "Installazione Sfondi (Copia Manuale in ~/.config/hypr/wallpaper)..."
mkdir -p "$CONFIG_DIR/hypr/wallpaper"
cp -r "$DOTFILES_DIR"/wallpapers/* "$CONFIG_DIR/hypr/wallpaper/"

echo -e "\n--- 🚀 Fase 3: Post-Installazione Zsh (Ordine Corretto) ---"

# 3.1. Installazione Zsh Plugin (PRIMA di stow)
echo "Installazione Zsh Plugins e Framework..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 3.2. Installazione Zsh (STOW - DOPO i plugin)
echo "Installazione configurazione Zsh (Stow)..."
rm -f "$HOME/.zshrc" # Rimuovi il file .zshrc di default creato da Oh My Zsh
stow -t "$HOME" $PACKAGES_HOME
if [ $? -ne 0 ]; then
    echo "ERRORE: Installazione Zsh (Stow) fallita."
    exit 1
fi

# 3.3. Correzione Permessi Script
echo "Impostazione permessi per gli script..."
chmod +x "$CONFIG_DIR"/hypr/scripts/*
chmod +x "$CONFIG_DIR"/hypr/UserScripts/*
chmod +x "$CONFIG_DIR"/hypr/initial-boot.sh

# 3.4. Imposta Zsh come shell di default (L'UNICO MODO POSSIBILE)
if [ -f /usr/bin/zsh ]; then
    echo "---"
    echo "ATTENZIONE: Lo script ora tenterà di impostare Zsh come shell di default."
    echo "Inserisci la password di '$USER' (la tua password di login) quando richiesta."
    echo "---"
    
    # Questo comando chiederà la password interattivamente
    chsh -s /usr/bin/zsh
    
    if [ $? -ne 0 ]; then
        echo "ERRORE: Cambio shell fallito. Eseguilo manualmente: chsh -s /usr/bin/zsh"
    fi
else
    echo "ATTENZIONE: /usr/bin/zsh non trovato."
fi

echo -e "\n✅ Installazione completata! Verificare l'ambiente:"
echo "   1. Riavvia la sessione (Logout e Login)."
echo "   2. Controlla che Hyprland, Waybar e Rofi siano caricati correttamente."
echo "   3. (Ora puoi avviare 'exec zsh' per vedere il risultato immediato)"

# fine dello script