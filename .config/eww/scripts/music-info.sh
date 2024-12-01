#!/usr/bin/env bash
# scripts by adi1090x

## Get data
STATUS="$(mpc status)"
COVER="/tmp/.music_cover.png"
MUSIC_DIR="$(xdg-user-dir MUSIC)"

## Get status
get_status() {
	if [[ $STATUS == *"[playing]"* ]]; then
		echo "󰏤"
	else
		echo "󰐊"
	fi
}

## Get song
get_song() {
	song=`mpc -f %title% current`
	if [[ -z "$song" ]]; then
		echo "Offline"
	else
		echo "$song"
	fi	
}

## Get artist
get_artist() {
	artist=`mpc -f %artist% current`
	if [[ -z "$artist" ]]; then
		echo ""
	else
		echo "$artist"
	fi	
}

## Get time
get_time() {
	time=`mpc status|awk '/%\)/{print $4}'|tr -d '(%)'`
	if [[ -z "$time" ]]; then
		echo "0"
	else
		echo "$time"
	fi
}
get_ctime() {
	ctime=`mpc status | awk '/#/{print $3}' | sed 's|/.*||g'`
	if [[ -z "$ctime" ]]; then
		echo "0:00"
	else
		echo "$ctime"
	fi	
}
get_ttime() {
	ttime=`mpc -f %time% current`
	if [[ -z "$ttime" ]]; then
		echo "0:00"
	else
		echo "$ttime"
	fi	
}

## Get cover
get_cover() {
	previewdir="$(xdg-user-dir CACHE)/thumbnails/music"
	previewname="$previewdir/$(mpc --format %album% current | base64 -w 999).png"
	filename="$(mpc --format "$MUSIC_DIR"/%file% current)"

	mkdir -p $previewdir
	[ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=360:360 "$previewname" > /dev/null 2>&1
	STATUS=$?

	# Check if the file has a embbeded album art
	if [ "$STATUS" -eq 0 ];then
		echo "$previewname"
	else
		echo "./images/music.svg"
	fi
}

## Execute accordingly
case $1 in
  "--song")   get_song ;;
  "--artist") get_artist ;;
  "--status") get_status ;;
  "--time")   get_time ;;
  "--ctime")  get_ctime ;;
  "--ttime")  get_ttime ;;
  "--cover")  get_cover ;;
  "--toggle") mpc -q toggle ;;
  "--next")   mpc -q next ;;
  "--prev")   mpc -q prev ;;
esac
