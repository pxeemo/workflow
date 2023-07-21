function screen-rec --description 'Record video from screen'
    mkdir -p $HOME/vid/scr
    cd $HOME/vid/scr
    wf-recorder \
    -aalsa_input.pci-0000_00_1f.3.analog-stereo.monitor \
    -xyuv420p -f $(date +%s).mkv
    prevd
end
