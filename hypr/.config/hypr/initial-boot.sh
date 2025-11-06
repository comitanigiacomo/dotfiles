#!/bin/bash

# --- Imposta il percorso del tuo sfondo ---
WALLPAPER_PATH="$HOME/.config/hypr/wallpaper/Beach-Dark.png"

# --- Avvio di Wallust per i colori del tema ---
if [ -f "$WALLPAPER_PATH" ]; then
    wallust run "$WALLPAPER_PATH"
    # NOTA: Rimossa la '&'. Aspettiamo che wallust finisca
    # prima di lanciare waybar.
fi

# --- Avvio del Gestore di Sfondo (swww) ---
swww init
# NOTA: Rimossa la '&'. Aspettiamo che il daemon sia pronto.

# Aggiungiamo un piccolo ritardo per sicurezza
sleep 0.5 

if [ -f "$WALLPAPER_PATH" ]; then
    swww img "$WALLPAPER_PATH" --transition-type outer &
fi

# --- Avvio di Waybar ---
killall -q waybar
# Aggiungiamo un ritardo per permettere a wallust di scrivere i file CSS
sleep 0.5 
waybar -c $HOME/.config/waybar/config -s $HOME/.config/waybar/style.css &

# --- Avvio del Centro Notifiche ---
swaync &