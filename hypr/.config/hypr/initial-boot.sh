#!/bin/bash

# --- Imposta il percorso del tuo sfondo ---
WALLPAPER_PATH="$HOME/.config/hypr/wallpaper/Beach-Dark.png"

# --- Avvio di Wallust per i colori del tema ---
if [ -f "$WALLPAPER_PATH" ]; then
    wallust run "$WALLPAPER_PATH"
fi

# --- Avvio del Gestore di Sfondo (swww) ---
swww init

sleep 0.5 

if [ -f "$WALLPAPER_PATH" ]; then
    swww img "$WALLPAPER_PATH" --transition-type outer &
fi

# --- Avvio di Waybar ---
killall -q waybar
sleep 0.5 
waybar -c $HOME/.config/waybar/config -s $HOME/.config/waybar/style.css &

# --- Avvio del Centro Notifiche ---
swaync &