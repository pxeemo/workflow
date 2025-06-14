#!/bin/env bash

wallpaper="${XDG_CONFIG_DIR:-$HOME/.config}/hypr/wallpaper.png"

magick "$@" "$wallpaper"
swww img "$wallpaper"

notify-send --icon="$wallpaper" --transient "Wallpaper" "New wallpaper applied"

