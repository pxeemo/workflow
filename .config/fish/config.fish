if test -f ~/.config/user-dirs.dirs
    sed '/^#/d;s/^/set -x /;s/=/ /' ~/.config/user-dirs.dirs | source
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr runat 'systemd-run --user --on-calendar'
    abbr runafter 'systemd-run --user --on-active'
    abbr webcam 'mpv --vf=hflip --profile=low-latency --untimed av://v4l2:/dev/video0'
    abbr nmcon 'nmcli device wifi connect'
    abbr nmre 'nmcli device wifi rescan'

    zoxide init fish | source
end
