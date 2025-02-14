function ts --description "convert mkv and ass to srt"
    set _flag_max 0 # sub stream index (default: 0)
    argparse '#max' e y 'l/lang=' 'i/index=' -- $argv
    argparse --min-args=1 -- $argv
    or return 5

    for org in $argv
        test -f $org
        or echo "$org: Is not a file" && return 1

        if set -q _flag_lang
            set srt (path change-extension $_flag_lang.srt $org)
        else
            set srt (path change-extension srt $org)
        end
        if set -q _flag_index
            ffmpeg -loglevel error -i $org -map $_flag_index $_flag_y $srt
        else
            ffmpeg -loglevel error -i $org -map 0:s:$_flag_max $_flag_y $srt
        end

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
