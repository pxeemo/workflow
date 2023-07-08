function ls --wraps='exa -lFa' --description 'alias ls exa'
    exa -lFa --icons --git -stype $argv
end
