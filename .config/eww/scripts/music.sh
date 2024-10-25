#!/usr/bin/env bash

## Get data
MUSIC_DIR="/home/pxeemo/mus/"
MUSIC_INFO='{"toggle_icon":"󰐊"}'
MUSIC_TIME='{"time":"0:00"}'

get_info() {
    # set toggle icon
	if [[ "$(mpc status)" == *"[playing]"* ]]; then
		MUSIC_INFO="$(echo "$MUSIC_INFO" | jq -Mc '.toggle_icon="󰏤"')"
	else
		MUSIC_INFO="$(echo "$MUSIC_INFO" | jq -Mc '.toggle_icon="󰐊"')"
	fi

    # Get track and artist name
	track="$(mpc -f %title% current)"
	artist="$(mpc -f %artist% current)"
	MUSIC_INFO="$(echo "$MUSIC_INFO" | jq -Mc ".track=\"$track\"")"
	MUSIC_INFO="$(echo "$MUSIC_INFO" | jq -Mc ".artist=\"$artist\"")"

    # Get cover
	thumbnail="$(thumbnailer "$(mpc --format "$MUSIC_DIR"/%file% current)")"
	MUSIC_INFO="$(echo "$MUSIC_INFO" | jq -Mc --arg c "$thumbnail" '.cover=$c')"

	echo "$MUSIC_INFO"
}


get_time() {
    # time percent
	perc="$(mpc status | awk '/%\)/ {print $4}' | tr -d '(%)')"
	MUSIC_TIME="$(echo "$MUSIC_TIME" | jq -Mc --arg t "$perc" '.perc=$t')"

    # current time
	current="$(mpc status | awk '/#/{print $3}' | sed 's|/.*||g')"
	MUSIC_TIME="$(echo "$MUSIC_TIME" | jq -Mc --arg t "${current:-"0:00"}" '.current=$t')"

    # total time
	total="$(mpc -f %time% current)"
	MUSIC_TIME="$(echo "$MUSIC_TIME" | jq -Mc --arg t "${total:-"0:00"}" '.total=$t')"

	echo "$MUSIC_TIME"
}

case "$1" in
    --info)
        get_info
        while : ; do
            [ "$(mpc idle)" == "player" ] || continue
            get_info
        done
    ;;
    --time) 
        get_time
    ;;
esac
