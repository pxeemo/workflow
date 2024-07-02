function scred --wraps="which" --description 'open scripts in nvim'
    $EDITOR (which $argv)
end
