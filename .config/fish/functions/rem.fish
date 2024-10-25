function rem
  pacman -Qq | fzf -q $argv[1] -m --preview 'paru -Qi {1}' | xargs -ro sudo paru -Rs
end
