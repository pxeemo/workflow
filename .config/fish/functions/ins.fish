function ins
    pacman -Sl --color=always | \
        fzf --ansi --nth=2 --multi --preview 'pacman -Si {1}/{2}' --query "$argv[1]" | \
        sed -E -e 's/([^ ]+) ([^ ]+).*/\1\/\2/g' | \
        xargs -ro sudo pacman -S
end
