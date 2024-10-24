#!/usr/bin/env bash

spaces() {
    hyprctl workspaces -j | jq -Mc --arg active "$1" --argjson urgent "$2" 'map({
    id: .id | tostring, 
    active: (.id | tostring == $active), 
    urgent: [.id] | inside($urgent)
}) | .=sort_by(.id)'
}

activews=$(hyprctl activeworkspace -j | jq '.id')
urgentwins='[]'
urgentws=$(hyprctl clients -j | jq -Mc --argjson wins "$urgentwins" '[.[] | select([.address] | inside($wins)) | .workspace.id]')

spaces "$activews" "$urgentws"
socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
case "${line%>>*}" in # match "event" from "event>>details..."
    "urgent")
        # get address of the urgent windows (if it's not already active)
        urgentwins="$(echo "$urgentwins" | \
            jq -Mc --arg win "0x${line#*>>}" --arg active "$activewin" \
            '. += [$win] | unique | map(select(. != $active))')"

        # get the workspaces which contians the urgent windows
        urgentws="$(hyprctl clients -j | \
            jq -Mc --argjson wins "$urgentwins" \
            '[.[] | select([.address] | inside($wins)) | .workspace.id]')"
        ;;
    "workspace")
        activews="${line#*>>}"
        ;;
    "activewindowv2"|"closewindow")
        chdwin="0x${line#*>>}"
        if [ $(echo "$urgentwins" | jq 'length') -gt 0 ]; then
            # check if active window is marked as urgent
            urgentwins=$(echo $urgentwins | jq --arg active $chdwin \
                'map(select(. != $active))')
            urgentws="$(hyprctl clients -j | \
                jq -Mc --argjson wins "$urgentwins" \
                '[.[] | select([.address] | inside($wins)) | .workspace.id]')"
        fi
        ;;
esac

spaces "$activews" "$urgentws"
done
