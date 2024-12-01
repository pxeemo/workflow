#!/usr/bin/env bash

IS_CHARGING=
PERC=

get() {
    status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
    charging=$(echo "$status" | grep -ce 'state: *charging')
    percentage=$(echo "$status" | awk -F ' +|%' '/percentage/{print $3}')
    
    if [ "$charging" != "$IS_CHARGING" ] && [ -n "$IS_CHARGING" ]; then
        if [ "$charging" == 1 ]; then
            notify-send -i "../images/battery/1-99.svg" "Battery" \
                "Battery is charging."
        else
            notify-send -i "../images/battery/0-60.svg" "Battery" \
                "Battery is not charging."
        fi
    fi
    IS_CHARGING="$charging"

    if [ "$percentage" -eq 25 ] && [ "$PERC" -gt "$percentage" ]; then
            notify-send -i "../images/battery/0-20.svg" "Battery" \
                "Battery is low. Please plug in the battey."
    fi
    PERC="$percentage"

    echo '{"charging": null, "percentage": null}' | \
        jq -Mc --arg charging "$charging" --arg percentage "$percentage" \
        '.charging = $charging | .percentage = ($percentage | tonumber)'
}

# exit if upower fails to get battery
upower -e | grep -q battery || exit 1

get
upower -m | while read; do
    get
done
