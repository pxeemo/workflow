#!/usr/bin/env bash

if [ "$1" == "next" ]; then
    keyboard=$(hyprctl devices -j | jq -r '.keyboards.[] | select(.main) | .name')
    hyprctl switchxkblayout "$keyboard" next 
    exit
fi

hyprctl devices -j | jq -r '.keyboards.[] | select(.main == true) | .active_keymap'
socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
    echo "$line" | awk -F, '/^activelayout/{print$NF}'
done
