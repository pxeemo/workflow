#!/bin/bash

swayidle -w \
    timeout 300 '~/.config/hypr/lock.sh delayed' \
    timeout 600 'hyprctl dispatch "dpms off"' \
    timeout 1200 'systemctl suspend' \
    before-sleep '~/.config/hypr/lock.sh immediate' \
    lock '~/.config/hypr/lock.sh immediate'
