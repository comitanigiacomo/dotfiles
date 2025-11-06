#!/bin/bash

# --- IMPOSTA IL TUO SFONDO ---
# Definisci il percorso del tuo sfondo preferito
# NOTA: Sostituisci questo percorso con un'immagine reale!
WALLPAPER_PATH="$HOME/.config/hypr/wallpaper/Beach-Dark.png"
# --- Avvio di Wallust per i colori del tema ---
# (Questo ora funzionerà perché gli stiamo dando un file)
if [ -f "$WALLPAPER_PATH" ]; then
    wallust run "$WALLPAPER_PATH" &
else
    echo "Sfondo non trovato in $WALLPAPER_PATH, avvio wallust fallito." &
fi

# --- Avvio del Gestore di Sfondo (swww) ---
# (Questo sostituisce lo script Wallpapers.sh mancante)
swww init &
swww img "$WALLPAPER_PATH" --transition-type outer &

# --- Avvio di Waybar ---
killall -q waybar
waybar &

# --- Avvio del Centro Notifiche ---
swaync &