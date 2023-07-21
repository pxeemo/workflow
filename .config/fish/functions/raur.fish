function raur
paru -Qq | fzf -q "$argv[1]" -m --preview 'paru -Qi {1}' | xargs -ro paru -Rns
end
