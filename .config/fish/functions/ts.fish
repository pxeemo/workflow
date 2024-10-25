function ts --description 'convert mkv and ass to srt'
  set _flag_max 0 # subtitle stream index
  argparse "#max" -- $argv
  for org in $argv
    set -l srt (path change-extension srt $org)
    ffmpeg -i $org -map 0:s:$_flag_max $srt

    ffasrt $srt
  end
end
