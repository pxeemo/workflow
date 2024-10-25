#!/usr/bin/env bash

option1="Active Window"
option2="Select Area"
option3="Text Scanner (OCR)"
option4="QR Code Scanner"
option5="Screen Record"

choice="$(printf '%s\n' "$option1" "$option2" "$option3" "$option4" "$option5" | wofi -dp Screenshot)"
sleep .2

case "$choice" in
    "$option1")
        grimmor --blur-frame --notify --cursor copy active
        ;;
    "$option2")
        grimmor --blur-frame --notify --freeze copy area
        ;;
    "$option3")
        lang="$(tesseract --list-langs | wofi -dp Languages)"
        text="$(grim -g "$(slurp)" - | tesseract - - -l "$lang")"
        wl-copy "$text" && notify-send -a Scanner "Text copied" "$text"
        ;;
    "$option4")
        text="$(grim -g "$(slurp)" - | zbarimg -)"
        wl-copy "$text" && notify-send -a Scanner "Text copied" "$text"
        ;;
    "$option5")
        kitty -e fish -c screen-rec
        ;;
esac

