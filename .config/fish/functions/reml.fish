function reml --description 'uninstall large packages need to be upgraded'
    set -l pkgs (pacman -Qui | grep -E '^(Name|Installed)' | cut -f2 -d':' | paste - - | column -t | grep MiB | sort -nrk 2 | bat)
    set -l to_remove (echo $pkgs | fzf -m | cut -f1 -d' ')
    sudo pacman -Rscd $to_remove
end
