function ls --wraps='eza -lFa' --description 'alias ls eza'
  eza -lFa --icons --git -stype $argv
end
