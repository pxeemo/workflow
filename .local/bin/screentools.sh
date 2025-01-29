#!/usr/bin/env bash

option=("Active Window" "Select Area" "Text Scanner (OCR)" "QR Code Scanner"
"Screen Record" "Colorpicker" "Magnifier" "Key Logger")

choice=$(printf '%s\n' "${option[@]}" | wofi -dp "Screen tool")
sleep .2

case "$choice" in
    ${option[0]}) grimmor --blur-frame --notify --cursor copy active ;;
    ${option[1]}) grimmor --blur-frame --notify --freeze copy area ;;
    ${option[2]})
        lang=$(tesseract --list-langs | wofi -dp Languages)
        text=$(grim -g "$(slurp)" - | tesseract - - -l "$lang")
        wl-copy "$text" && notify-send -a Scanner "Text copied" "$text"
        ;;
    ${option[3]})
        text=$(grim -g "$(slurp)" - | zbarimg -)
        wl-copy "$text" && notify-send -a Scanner "Text copied" "$text"
        ;;
    ${option[4]}) if ! pkill -2 -f wf-recorder; then screenrec; fi ;;
    ${option[5]}) hyprpicker -a ;;
    ${option[6]}) 
        if [[ "$XDG_CURRENT_DESKTOP" == "niri" ]]; then
            wooz
        else
            hyprmag --radius 150 --scale 2
        fi
        ;;
    ${option[7]}) 
        if ! pkill wshowkeys; then
            wshowkeys -F "JetBrainsMono NF,22" -a bottom
        fi
        ;;
    *) exit ;;
esac
