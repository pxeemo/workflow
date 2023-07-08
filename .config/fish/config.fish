if status is-interactive
    # Commands to run in interactive sessions can go here
end

if not contains $HOME/.local/bin $PATH
    set -ga PATH $HOME/.local/bin
end
