function rem
    pacman -Q --color=always | \
        fzf --ansi --multi --preview 'paru -Qi {1}' --query "$argv" | \
        xargs -ro sudo paru -Rs
end
