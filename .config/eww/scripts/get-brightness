#!/usr/bin/env bash

command -v brightnessctl >/dev/null || exit 1

brightnessctl -m | cut -d, -f4 | tr -d '%'
udevadm monitor --udev | while read -r line; do
    if echo $line | grep -q backlight >/dev/null; then
        brightnessctl -m | cut -d, -f4 | tr -d '%'
    fi
done
