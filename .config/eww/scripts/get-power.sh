#!/usr/bin/env bash

IS_CHARGING=
IS_PLUGGED=
PERC=
NOTIF_ID=0

notify() {
    NOTIF_ID=$(notify-send --icon "$(realpath "$1")" \
        --expire-time 3000 \
        --print-id \
        --replace-id "$NOTIF_ID" \
        --urgency low \
        "Battery" "$2")
}

get_battery() {
    status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
    charging=$(echo "$status" | grep -ce 'state: *charging')
    percentage=$(echo "$status" | awk -F ' +|%' '/percentage/{print $3}')
    
    if [ "$charging" != "$IS_CHARGING" ] && [ -n "$IS_CHARGING" ]; then
        if [ "$charging" != 1 ] && [ "$IS_PLUGGED" == "yes" ]; then
            notify "../images/battery/1-99.svg" "Battery is full."
        fi
    fi
    IS_CHARGING="$charging"

    if [ "$percentage" -eq 25 ] && [ "$PERC" -gt "$percentage" ]; then
        notify "../images/battery/0-20.svg" "Battery is low. Please plug in the battey."
    fi
    PERC="$percentage"

    echo '{"charging": null, "percentage": null}' | \
        jq -Mc --arg charging "$charging" --arg percentage "$percentage" \
        '.charging = $charging | .percentage = ($percentage | tonumber)'
}

get_supply() {
    status=$(upower -i /org/freedesktop/UPower/devices/line_power_AC)
    plugged=$(echo "$status" | awk '/online/{print $2}')
    if [ "$plugged" != "$IS_PLUGGED" ]; then
        if [ "$plugged" == "yes" ]; then
            notify "../images/FluentPlugConnected24Regular.svg" "Power supply plugged in."
        else
            notify "../images/FluentPlugDisconnected24Regular.svg" "Power supply disconnected."
        fi
    fi
    IS_PLUGGED="$plugged"
}

# exit if upower fails to get battery
upower -e | grep -q battery || exit 1

cd "$(dirname "$(realpath "$0")")"
get_battery
upower -m | while read -r line; do
    if echo "$line" | grep -q "line_power_AC"; then
        get_supply
    else
        get_battery
    fi
done
