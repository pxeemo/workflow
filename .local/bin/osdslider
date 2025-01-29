#!/usr/bin/env bash

set -e

slider="$1-osd"
action=$2
lockfile="$XDG_RUNTIME_DIR/$slider.lock"

if [[ "$slider" == "brightness-osd" ]]; then
    if [[ "$action" == "up" ]]; then
        brightnessctl --min-value=6 --quiet --exponent=4 set +5%
    else
        brightnessctl --min-value=6 --quiet --exponent=4 set 5%-
    fi
    laststate=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
    eww update current-brightness-state="$laststate"
else 
    if [[ "$action" == "up" ]]; then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%+
    else
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%-
    fi
    laststate=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $NF*100}')
    eww update "current-volume-state=$laststate"
    eww update "volperc=$laststate"
fi

if [ -f "$lockfile" ]; then
    echo $(( $(cat "$lockfile")+1 )) > "$lockfile"
    exit 0
fi

echo 1 > "$lockfile"
trap "rm -rf $lockfile" EXIT
eww open "$slider"
sleep 0.01
eww update "$slider-reveal=true"
lastrun=0

function getstate {
    if [[ "$1" == "brightness-osd" ]]; then
        brightnessctl -m | cut -d, -f4 | tr -d '%'
    else 
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $NF*100}'
    fi
}

while true; do
    currentrun=$(cat "$lockfile")
    currentstate=$(getstate "$slider")
    if [ "$currentrun" -eq "$lastrun" ] && [ "$currentstate" -eq "$laststate" ]; then
        eww update "$slider-reveal=false"
        sleep .6
        eww close "$slider"
        break
    else
        lastrun=$currentrun
        laststate=$currentstate
    fi
    sleep 3
done

rm "$lockfile"
