function lf
    set last_dir (command lf -print-last-dir $argv)
    if test -n $last_dir
        cd $last_dir
    end
end
