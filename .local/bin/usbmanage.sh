#!/bin/bash

# drive="$(udiskie-info -a | wofi -d)"
drive="$(lsblk -l -o 'name,size,type,mountpoint' -n | \
    awk '{ if($3=="part"||$3=="rom") {print $1,$2} }' | \
    column -tR2 | sort -r | wofi -d | awk '{print "/dev/"$1}')"
[[ $drive ]] || exit
action="$(printf '%s\n' 'Mount' 'Unmount' 'Eject' | wofi -d)"
[[ $action ]] || exit

case "$action" in
    'Mount') 
        result="$(udisksctl mount -b "$drive" 2>&1)"
        ;;
    'Unmount') 
        result="$(udisksctl unmount -b "$drive" 2>&1)"
        ;;
    'Eject') 
        result="$(udisksctl power-off -b "$drive" 2>&1)"
        ;;
    *) exit ;;
esac
notify-send "USB Managment" "$result"
wl-copy "$(echo "$result" | awk '{print$NF}')"
