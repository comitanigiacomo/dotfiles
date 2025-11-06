#!/bin/bash

# --- Variabili di Sistema ---
DOTFILES_DIR=$HOME/dotfiles
CONFIG_DIR=$HOME/.config

# --- Elenco Pacchetti Personalizzato (Basato sulla TUA Struttura) ---

# Pacchetti "Piatti" (file subito dentro, come 'rofi' e 'wallust')
PACKAGES_FLAT="rofi gtk-3.0 gtk-4.0 wallust"

# Pacchetti "Annidati" (file dentro .config/NOME, come 'hypr', 'kitty', 'waybar')
PACKAGES_NESTED="hypr kitty nvim swaync waybar"

# Pacchetti "Home" (come 'zsh')
PACKAGES_HOME="zsh"

# --- 1. Controllo Essenziale ---
if ! command -v stow &> /dev/null; then
    echo "Errore: 'stow' non è installato. Installalo prima di procedere."
    exit 1
fi
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Errore: La cartella dotfiles non si trova in $DOTFILES_DIR."
    exit 1
fi

echo "--- 🧹 Fase 1: Pulizia dei Conflitti (Definitiva) ---"
# Rimuove le cartelle locali E i file di conflitto

function clean_config {
    echo "Pulizia $1..."
    rm -rf "$CONFIG_DIR/$1"
}

# Pulizia di tutte le cartelle che verranno gestite da stow
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

echo -e "\n--- 🛠️ Fase 2: Installazione con STOW (Struttura Mista Personalizzata) ---"

# 2.1. Installazione Pacchetti Annidati (Hypr, Kitty, ecc.)
# Questo usa il flag --dir per scavare nel percorso .config interno
echo "Installazione Pacchetti Annidati (Hypr, Kitty, Waybar...)"
for pkg in $PACKAGES_NESTED; do
    echo "-> Installando (annidato) $pkg"
    # Assumiamo che tutti questi abbiano la struttura 'pacchetto/.config/pacchetto'
    stow -t "$CONFIG_DIR" --dir "$pkg"/.config "$pkg"
    if [ $? -ne 0 ]; then
        echo "ERRORE: Installazione $pkg fallita. Controlla la struttura interna."
    fi
done

# 2.2. Installazione Pacchetti Piatti (Rofi, Wallust, ecc.)
echo "Installazione Pacchetti Piatti (Rofi, Wallust, GTK...)"
stow -t "$CONFIG_DIR" $PACKAGES_FLAT
if [ $? -ne 0 ]; then
    echo "ERRORE: Installazione Pacchetti Piatti fallita."
fi

# 2.3. Installazione Zsh (Ora senza conflitti)
echo "Installazione Zsh..."
stow -t "$HOME" $PACKAGES_HOME
if [ $? -ne 0 ]; then
    echo "ERRORE: Installazione Zsh fallita."
fi

# NOTA: La sezione "Risoluzione Manuale (GTK Settings)" è stata rimossa.
# Non è necessaria perché GTK è ora gestito correttamente da $PACKAGES_FLAT.

echo -e "\n--- 🚀 Fase 3: Post-Installazione e Permessi ---"

# 3.1. Installazione Zsh Plugin (Ora funzionerà perché abbiamo pulito .oh-my-zsh)
echo "Installazione Zsh Plugins e Framework..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 3.2. Correzione Permessi Script
echo "Impostazione permessi per gli script..."
# Ora questi percorsi ESISTONO perché la Fase 2.1 ha funzionato
chmod +x "$CONFIG_DIR"/hypr/scripts/*
chmod +x "$CONFIG_DIR"/hypr/UserScripts/*
chmod +x "$CONFIG_DIR"/hypr/initial-boot.sh

echo -e "\n✅ Installazione completata! Verificare l'ambiente:"
echo "   1. Riavvia la sessione (Logout e Login)."
echo "   2. Controlla che Hyprland, Waybar e Rofi siano caricati correttamente."

# fine dello script