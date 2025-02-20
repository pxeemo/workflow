function rem
    pacman -Q --color=always | \
        fzf --ansi --multi --preview 'paru -Qi {1}' --query "$argv" | \
        sed -E -e 's/([^ ]+).*/\1/g' | \
        xargs -ro sudo paru -Rs
end
