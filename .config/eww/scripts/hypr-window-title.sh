#!/usr/bin/env bash
hyprctl activewindow -j | jq --raw-output .title
socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - \
    | stdbuf -o0 awk -F '>>|,' '/^activewindow>>/{print $3}'
