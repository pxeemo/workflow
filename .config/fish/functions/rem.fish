function rem
  pacman -Qq | \
  fzf --multi --preview 'paru -Qi {1}' --query "$argv" | \
  xargs -ro sudo paru -Rs
end
