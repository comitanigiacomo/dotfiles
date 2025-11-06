#!/bin/bash

# --- File marker per l'avvio unico ---
# Se questo file esiste, significa che abbiamo già impostato lo sfondo. Esci.
MARKER_FILE="$HOME/.config/hypr/.wallpaper_set_done"
if [ -f "$MARKER_FILE" ]; then
    # Avvia Waybar e SwayNC (devono partire sempre, ma lo sfondo è già a posto)
    killall -q waybar
    waybar &
    swaync &
    exit 0
fi

# --- IMPOSTAZIONE PRIMO AVVIO (Se il marker non esiste) ---

# 1. Imposta il percorso (come prima)
WALLPAPER_PATH="$HOME/.config/hypr/wallpaper/Beach-Dark.png"

# 2. Avvio di Wallust per i colori
if [ -f "$WALLPAPER_PATH" ]; then
    wallust run "$WALLPAPER_PATH" &
fi

# 3. Avvio Sfondo (SENZA transizione, per renderlo istantaneo)
# (swww init è già in hyprland.conf)
if [ -f "$WALLPAPER_PATH" ]; then
    swww img "$WALLPAPER_PATH" --transition-type none
fi

# 4. Avvio Waybar e SwayNC
killall -q waybar
waybar &
swaync &

# 5. Crea il file marker per non eseguire più questa impostazione
touch "$MARKER_FILE"