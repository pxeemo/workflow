function ls --wraps='eza' --description='alias ls eza'
    eza \
        --almost-all \
        --long \
        --classify \
        --icons \
        --git \
        --group-directories-first \
        --sort=modified \
        --time-style=relative \
        $argv
end
