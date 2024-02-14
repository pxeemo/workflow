function ls --wraps='eza -lFa' --description 'alias ls eza'
  eza -AlF --icons --git -stype $argv
end
