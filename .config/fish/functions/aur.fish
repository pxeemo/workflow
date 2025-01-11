function aur
    paru -Slq | fzf -q $argv[1] -m --preview 'paru -Si {1}' | xargs -ro paru -S
end
