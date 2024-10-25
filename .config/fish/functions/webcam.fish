function webcam
    mpv --vf=hflip --profile=low-latency --untimed av://v4l2:/dev/video0 $argv
end
