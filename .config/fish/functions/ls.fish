function ls --wraps='eza -lFa' --description 'alias ls eza'
  eza -AlF -stype --icons --git --time-style="relative" $argv
end
