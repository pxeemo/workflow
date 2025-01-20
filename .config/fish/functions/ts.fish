function ts --description "convert mkv and ass to srt"
    set _flag_max 0 # sub stream index (default: 0)
    argparse '#max' e -- $argv
    argparse --min-args=1 -- $argv
    or return 5

    for org in $argv
        test -f $org
        or echo "$org: Is not a file" && return 1

        set -l srt (path change-extension srt $org)
        ffmpeg -v 8 -i $org -map 0:s:$_flag_max $srt

        if set -q _flag_e # sub is english
            sed -i -E \
                -e 's/ face="[^"]+"//g' \
                -e 's/ size="[0-9]+"//g' \
                $srt
            echo $srt
        else
            ffasrt $srt
        end
    end
end
