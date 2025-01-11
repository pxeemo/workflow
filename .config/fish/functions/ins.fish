function ins
    pacman -Slq | fzf -q $argv[1] -m --preview 'paru -Si {1}' | xargs -ro sudo pacman -S
end
