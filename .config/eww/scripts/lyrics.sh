#!/bin/bash

# FILE="$1"
FILE="$HOME/mus/AURORA - Runaway.mp3"
json=`exiftool -j "$FILE"`
lyrics=`echo "$json" | jq -Mc '[.[]|to_entries|.[]|select(
    .key|test("Lyrics.?{4}"))|.value|split("\n").[]|split("]")|map(
    select([])|sub("^[ []";""))|{time:.[0],text:.[1]}|select(.text != "")]'`
echo -e $lyrics
