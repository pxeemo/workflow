function lf
    set last_dir (command lf -print-last-dir $argv)
    if test -n $last_dir
        z $last_dir
    end
end
