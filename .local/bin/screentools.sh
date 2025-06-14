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
    ${option[5]}) 
        file="$(mktemp).png"
        color=$(niri msg pick-color | grep -Eo '#[0-9a-fA-F]{6}')
        wl-copy "$color"
        magick -size 1x1 -background "$color" xc: "$file"
        notify-send -a "Colorpicker" -i "$file" "Color copied" "$color"
        rm "$file"
        ;;
    ${option[6]}) wooz ;;
    ${option[7]}) 
        if ! pkill wshowkeys; then
            wshowkeys -F "JetBrainsMono NF,22" -a bottom
        fi
        ;;
    *) exit ;;
esac
