#!/usr/bin/env bash

get-kbd() {
    niri msg -j keyboard-layouts | jq -r '.names[.current_idx]'
}

get-kbd
niri msg -j event-stream | while read -r line; do
    id=$(echo "$line" | jq -Mcr '.KeyboardLayoutSwitched.idx')
    if [ "$id" != "null" ]; then
        get-kbd
    fi
done
