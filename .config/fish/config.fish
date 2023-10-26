if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr runat 'systemd-run --user --on-calendar'
    abbr runafter 'systemd-run --user --on-active'
    abbr webcam 'mpv av://v4l2:/dev/video0 --profile=low-latency --untimed'
    abbr doom '~/.config/emacs/bin/doom'
end

if not contains $HOME/.local/bin $PATH
    set -ga PATH $HOME/.local/bin
end
