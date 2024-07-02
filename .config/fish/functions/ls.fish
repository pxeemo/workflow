function ls --wraps='eza -lFa' --description 'alias ls eza'
  eza \
    --almost-all \
    --long \
    --classify \
    --icons \
    --git \
    --sort=type \
    --time-style=relative \
    $argv
end
