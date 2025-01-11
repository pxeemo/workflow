function screenrec --description 'Record video from screen'
    set -l adev (wpctl inspect @DEFAULT_AUDIO_SINK@ | awk -F'"' '/node.name/{print $2}')
    set -l screenrecdir $XDG_VIDEOS_DIR/screenrec
    test -d $screenrecdir
    or mkdir -p $screenrecdir
    pushd $screenrecdir
    wf-recorder \
        --audio=$adev.monitor \
        --pixel-format=yuv420p \
        --file=(date +%s).mkv
    popd
end
