function aur
    paru -Sl --color=always | \
        fzf --ansi --nth=2 --multi --query "$argv[1]" --preview 'paru -Si {1}/{2}' | \
        sed -E -e 's/([^ ]+) ([^ ]+).*/\1\/\2/g' | \
        xargs -ro paru -S
end
