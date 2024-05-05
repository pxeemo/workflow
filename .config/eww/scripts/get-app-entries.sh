#!/bin/bash

cachedir="${XDG_CAHCE_DIR-:$HOME/.cache}"
applistfile="$cachedir/applist.json" 
# if [ -e "$applistfile" ]; then
#     cat "$applistfile"
#     exit 0
# fi

entry_files="$(ls -1 /usr/share/applications/*.desktop)"
entry_files="$entry_files\n$(ls -1 "${XGD_DATA_DIR:-$HOME/.local/share}"/applications/*.desktop)"
ENTRIES='[]'

while IFS= read -r entry; do
    name="$(sed -ne 's/Name=//p' "$entry" | head -n 1)"
    icon="$(sed -ne 's/Icon=//p' "$entry")"
    exec="$(sed -ne 's/Exec=//p' "$entry")"

    if echo "$icon" | grep -q '/'; then
        icon="$(find -L "/home/pxeemo/.local/share/icons/Reversal-purple-dark" -type f -iname "$icon*" | head -n 1)"
    fi

    ENTRIES="$(echo "$ENTRIES" | jq -Mc --arg name "$name" --arg icon "$icon" --arg exec "$exec" '. += [{name: $name, icon: $icon, exec: $exec}]')"
done <<< "$entry_files"

[ -e "$cachedir" ] || mkdir -p "$cachedir" 
echo "$ENTRIES" > "$applistfile"
cat "$applistfile"

