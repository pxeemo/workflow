#!/usr/bin/env bash

# Variables
status="`mpc status`"
if [[ -z "$status" ]]; then
  prompt='Offline'
  mesg="MPD is Offline"
elif [[ "$status" == "vol"* ]]; then
  prompt="NO ONE"
  mesg="Stopped Playing :: --:--/--:--"
else
  prompt="`mpc -f "%artist%" current`"
  mesg="`mpc -f "%title%" current` :: `mpc status | grep "#" | awk '{print $3}'`"
fi

if [[ ${status} == *"[playing]"* ]]; then
  option_1=""
else
  option_1=""
fi
option_2=""
option_3=""
option_4=""
option_5=""
option_6=""

# Toggle Actions
active='-a ,'
urgent='-u ,'

# Repeat
if [[ ${status} == *"repeat: on"* ]]; then
    active+="5,"
elif [[ ${status} == *"repeat: off"* ]]; then
    urgent+="5,"
else
    option_5=" Parsing Error"
fi

# Random
if [[ ${status} == *"random: on"* ]]; then
    active+="6,"
elif [[ ${status} == *"random: off"* ]]; then
    urgent+="6,"
else
    option_6=" Parsing Error"
fi

# Single
if [[ ${status} == *"single: on"* ]]; then
    active+="0"
    option_7=""
elif [[ ${status} == *"single: off"* ]]; then
    urgent+="0"
    option_7=""
else
    option_7=" Parsing Error"
fi

# Rofi CMD
rofi_cmd() {
  rofi -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    ${active} ${urgent} \
    -markup-rows \
    -theme "mpd" \
    -select $option_1
}

# Actions
chosen="$(printf "%s\n" $option_7 $option_2 $option_3 $option_1 $option_4 $option_5 $option_6 | rofi_cmd)"
case ${chosen} in
    $option_1) mpc -q toggle && notify-send -u low -t 1000 " `mpc current`" ;;
    $option_2) mpc -q stop ;;
    $option_3) mpc -q prev && notify-send -u low -t 1000 " `mpc current`" ;;
    $option_4) mpc -q next && notify-send -u low -t 1000 " `mpc current`" ;;
    $option_5) mpc -q repeat ;;
    $option_6) mpc -q random ;;
    $option_7) mpc -q single ;;
esac
