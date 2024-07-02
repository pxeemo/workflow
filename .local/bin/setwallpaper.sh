#!/bin/bash

wallpaper="${XDG_CONFIG_DIR:-$HOME/.config}/hypr/wallpaper.webp"
monitors="$(hyprctl monitors -j | jq -r '.[].name')"

screenres="$(xrandr | grep -Po "\d+x\d+\+\d+\+\d+" | head -n 1)"
convert "$@" -resize "${screenres%x*}x" -gravity center -crop "$screenres" +repage "$wallpaper"

hyprctl hyprpaper unload "$wallpaper"
hyprctl hyprpaper preload "$wallpaper"
for monitor in $monitors; do
    hyprctl hyprpaper wallpaper "$monitor,$wallpaper"
done

notify-send "New wallpaper applied"

