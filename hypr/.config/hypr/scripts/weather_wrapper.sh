#!/bin/bash

SOURCE_SCRIPT="$HOME/.config/hypr/UserScripts/Weather.py"
CACHE_FILE="$HOME/.cache/open_meteo_cache.json"

case "$1" in
    "weather")
        OUTPUT=$(python3 "$SOURCE_SCRIPT")
        echo "$OUTPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('text', '...'))" 2>/dev/null
        ;;
    "location")
        if [ -f "$CACHE_FILE" ]; then
            python3 -c "import json; print(json.load(open('$CACHE_FILE')).get('place', 'Unknown'))" 2>/dev/null
        else
            echo "Loading..."
        fi
        ;;
esac