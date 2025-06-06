function reml --description 'uninstall large packages need to be upgraded'
    argparse u -- $argv
    set -l pkgs (pacman -Qi $_flag_u | awk -F ': ' '
        /^Name/{name=$2}
        /^Installed/{size=$2}
        /MiB$/{print name, size}' | sort -nrk 2 | column -t)
    set -l to_remove (printf '%s\n' $pkgs | fzf -m --preview "
        pacman -Rsp {1} --color=always | sed 's/.\+breaks dependency/;;/;
            s/ required by / dep breaks /'
    " | cut -f1 -d' ')
    if test (count $to_remove) -ne 0
        sudo pacman -Rscd $to_remove
    end
end
