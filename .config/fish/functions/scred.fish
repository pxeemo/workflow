function scred --wraps="which" --description 'open scripts in nvim'
    set script $HOME/.local/bin/$argv
    $EDITOR $script

    if test -f $script && test ! -x $script
        chmod +x $script
    end
end
