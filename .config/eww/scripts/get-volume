#!/usr/bin/env bash

wpctl get-volume @DEFAULT_SINK@ | awk '{if($NF=="[MUTED]"){print$NF}else{printf"%.0f\n",$NF*100}}'
# will return volume percentage or "[MUTED]" if it's muted

# pactl subscribe | while read -r line; do
#     if echo $line | grep change >/dev/null; then
#         wpctl get-volume @DEFAULT_SINK@ | awk '{if($NF=="[MUTED]"){print$NF}else{printf"%.0f\n",$NF*100}}'
#     fi
# done

# pw-mon | while read -r line; do
#     if echo "$line" | grep added >/dev/null; then
#         # wpctl get-volume @DEFAULT_SINK@ | awk '{if($NF=="[MUTED]"){print$NF}else{printf"%.0f\n",$NF*100}}'
#     fi
# done
