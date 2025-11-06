#!/bin/bash

# --- Variabili di Sistema ---
DOTFILES_DIR=$HOME/dotfiles
CONFIG_DIR=$HOME/.config

# --- Elenco Pacchetti Personalizzato (Basato sulla TUA Struttura) ---
# Pacchetti "Piatti" (file subito dentro, come 'rofi' e 'wallust')
PACKAGES_FLAT="rofi gtk-3.0 gtk-4.0 wallust"

# Pacchetti "Annidati" (file dentro .config/NOME, come 'hypr', 'kitty', 'waybar')
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
    # Crea la cartella di destinazione
    mkdir -p "$CONFIG_DIR/$pkg"
    # Copia il contenuto della sottocartella sorgente nella destinazione
    cp -r "$DOTFILES_DIR/$pkg"/.config/"$pkg"/* "$CONFIG_DIR/$pkg/"
    if [ $? -ne 0 ]; then
        echo "ERRORE: Copia $pkg fallita."
    fi
done

# 2.2. Installazione Pacchetti Piatti (COPIA MANUALE)
echo "Installazione Pacchetti Piatti (Copia Manuale: Rofi, Wallust, GTK...)"
for pkg in $PACKAGES_FLAT; do
    echo "-> Copiando (piatto) $pkg"
    # Crea la cartella di destinazione
    mkdir -p "$CONFIG_DIR/$pkg"
    # Copia il contenuto della cartella sorgente nella destinazione
    cp -r "$DOTFILES_DIR/$pkg"/* "$CONFIG_DIR/$pkg/"
    if [ $? -ne 0 ]; then
        echo "ERRORE: Copia $pkg fallita."
    fi
done

# 2.3. Installazione Zsh (STOW - L'unica eccezione)
echo "Installazione Zsh..."
stow -t "$HOME" $PACKAGES_HOME
if [ $? -ne 0 ]; then
    echo "ERRORE: Installazione Zsh fallita."
fi

echo -e "\n--- 🚀 Fase 3: Post-Installazione e Permessi ---"

# 3.1. Installazione Zsh Plugin (Ora funzionerà perché abbiamo pulito .oh-my-zsh)
echo "Installazione Zsh Plugins e Framework..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 3.2. Correzione Permessi Script
echo "Impostazione permessi per gli script..."
# Ora questi percorsi ESISTONO perché la Fase 2.1 (Copia) ha funzionato
chmod +x "$CONFIG_DIR"/hypr/scripts/*
chmod +x "$CONFIG_DIR"/hypr/UserScripts/*
chmod +x "$CONFIG_DIR"/hypr/initial-boot.sh

echo -e "\n✅ Installazione completata! Verificare l'ambiente:"
echo "   1. Riavvia la sessione (Logout e Login)."
echo "   2. Controlla che Hyprland, Waybar e Rofi siano caricati correttamente."

# fine dello script