#!/bin/bash

case "$1" in
    immediate)
        swaylock --screenshots --clock --effect-vignette 0.5:0.5 --separator-color fff000 --indicator-idle-visible --indicator-thickness 10 --inside-color 1e1e2ea5 --indicator-radius 100 --grace 1 --fade-in 0.3 --key-hl-color fff000 --line-color 00000000 --ring-color 893bff --effect-blur 7x5 --daemonize 
        ;;
    delayed)
        swaylock --screenshots --clock --effect-vignette 0.5:0.5 --separator-color fff000 --indicator-idle-visible --indicator-thickness 10 --inside-color 1e1e2ea5 --indicator-radius 100 --grace 8 --fade-in 0.3 --key-hl-color fff000 --line-color 00000000 --ring-color 893bff --effect-blur 7x5 --daemonize 
        ;;
    *) echo default ;;
esac
