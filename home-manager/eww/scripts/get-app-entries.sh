#!/usr/bin/env bash

cache_dir="${XDG_CAHCE_DIR:-$HOME/.cache}"
applist_file="$cache_dir/applist.json" 
# Entries cache
if [ -e "$applist_file" ]; then
    cat "$applist_file"
    exit 0
fi
gtk_theme="$(gtk-query-settings gtk-icon-theme | awk '{print$2}' | tr -d \")"
entry_files="$(ls -1 /usr/share/applications/*.desktop "${XGD_DATA_DIR:-$HOME/.local/share}"/applications/*.desktop)"
# entry_files="/usr/share/applications/firefox.desktop"
ENTRIES='[]'

while IFS= read -r entry; do
    name="$(sed -ne 's/Name=//p' "$entry" | head -n 1)"
    icon="$(sed -ne 's/Icon=//p' "$entry")"
    exec="$(sed -ne 's/Exec=//p' "$entry")"

    if ! echo "$icon" | grep -q '/'; then
        icon="$(find -L "$HOME/.local/share/icons/$gtk_theme" -type f -iname "$icon*" | head -n 1)"
    fi

    ENTRIES="$(echo "$ENTRIES" | jq -Mc --arg name "$name" --arg icon "$icon" --arg exec "$exec" '. += [{name: $name, icon: $icon, exec: $exec}]')"
done <<< "$entry_files"

[ -e "$cache_dir" ] || mkdir -p "$cache_dir" 
echo "$ENTRIES" > "$applist_file"
cat "$applist_file"

