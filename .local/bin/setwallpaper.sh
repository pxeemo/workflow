#!/bin/bash

wallpaper="${XDG_CONFIG_DIR:-$HOME/.config}/hypr/wallpaper.webp"

magick "$@" "$wallpaper"
swww img "$wallpaper"

notify-send "Wallpaper" "New wallpaper applied"

