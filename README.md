<h1 align="center">Dotfiles of <a href="https://github.com/pxeemo">pxeemo</a>!</h1>
<p align="center">My Linux distribution configuration files</p>

## Hyprland:

![shot1](screenshots/view.avif)

### See [Catppuccin](https://catppuccin-website.vercel.app/) for GTK & QT theme

# Installation
Needed `git` to clone this repo and `stow` to manage dotfiles:
```shell
git clone https://github,com/pxeemo/workflow.git
cd workflow
stow .
```

## Used Apps
#### PDF viewer
- [zathura](https://github.com/pwmt/zathura) with `zathura-pdf-poppler` or `zathura-pdf-mupdf` engine
#### File manager
- [lf](https://github.com/gokcehan/lf) &#8594; TUI file manager based on Vim
| file type | packages used for preview |
|:----------|:--------------------------|
| text/*    | `bat`                     |
| image/svg | `librsvg`, `imagemagick`  |
| image/*   | `imagemagick`             |
| */pdf     | `poppler`, `ghostscript`  |
| video/*   | `ffmpegthumbnailer`       |
| audio/*   | `exiftool`                |
#### Music player
- [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp) &#8594; Music player with [MPD](https://github.com/MusicPlayerDaemon/MPD)
#### Terminal
- [kitty](https://github.com/kovidgoyal/kitty) &#8594; Terminal emulator

#### Packages to be installed:
I recommend you adding [choatic aur](https://aur.chaotic.cx/) for faster installation without build.

```
hyprland hyprpaper hypridle hyprlock hyprpicker jq socat eww-git ncmpcpp
ffmpegthumnailer rsvg-convert imagemagick atool slurp dunst 
eza bat-extras bat lf fzf wl-clipboard kitty xdg-user-dirs fish mpd mpc mpv
wofi grim libnotify nwg-drawer
```
