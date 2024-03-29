#!/usr/bin/fish

set -l options 'Active Window' 'Select Area' 'Text Scanner (OCR)' 'QR Code Scanner' 'Screen Record'

set -l choice (printf '%s\n' $options | wofi -dp Screenshot)
sleep .2
switch $choice
case $options[1]
    grimblast --prettier --notify --cursor copy active
case $options[2]
    grimblast --prettier --notify copy area
case $options[3]
    set -l lang (tesseract --list-langs | wofi -dp Langs)
    set -l text (grim -g (slurp) - | tesseract - - -l $lang)
    wl-copy $text && notify-send -a Scanner "Text copied" $text
case $options[4]
    set -l text (grim -g (slurp) - | zbarimg -)
    wl-copy $text && notify-send -a Scanner "Text copied" $text
case $options[5]
    kitty -e "screen-rec"
case '*'
    exit 1
end
