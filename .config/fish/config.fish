if command xdg-user-dir
    set -x XDG_DESKTOP_DIR (xdg-user-dir DESKTOP)
    set -x XDG_DOWNLOAD_DIR (xdg-user-dir DOWNLOAD)
    set -x XDG_TEMPLATES_DIR (xdg-user-dir TEMPLATES)
    set -x XDG_PUBLICSHARE_DIR (xdg-user-dir PUBLICSHARE)
    set -x XDG_DOCUMENTS_DIR (xdg-user-dir DOCUMENTS)
    set -x XDG_MUSIC_DIR (xdg-user-dir MUSIC)
    set -x XDG_PICTURES_DIR (xdg-user-dir PICTURES)
    set -x XDG_VIDEOS_DIR (xdg-user-dir VIDEOS)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr runat 'systemd-run --user --on-calendar'
    abbr runafter 'systemd-run --user --on-active'
    abbr webcam 'mpv --vf=hflip --profile=low-latency --untimed av://v4l2:/dev/video0'
    # abbr doom '~/.config/emacs/bin/doom'

    zoxide init fish | source
end

if not contains $HOME/.local/bin $PATH
   set -ga PATH $HOME/.local/bin
end
