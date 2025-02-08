<h1 align="center">Dotfiles of <a href="https://github.com/pxeemo">pxeemo</a>!</h1>
<p align="center">My Linux distribution configuration files</p>

## [Hyprland](https://hyprland.org/)

![hyprland screenshot](./screenshots/hyprland.avif)

## [Niri](https://github.com/YaLTeR/niri)

![niri screenshot](./screenshots/niri.avif)

### See [Catppuccin](https://catppuccin-website.vercel.app/) for GTK & QT themes

# Installation

Needed `git` to clone this repo and `stow` to manage dotfiles:

```shell
git clone --depth=1 https://github.com/pxeemo/workflow.git ~/workflow
cd ~/workflow
stow .
```

## Used Apps

#### Session

- [kitty](https://github.com/kovidgoyal/kitty) &#8594; Terminal emulator
- [hypridle](https://github.com/hyprwm/hypridle) &#8594; Idle handler
- [hyprlock](https://github.com/hyprwm/hyprlock) &#8594; Lock screen
- [swww](https://github.com/LGFae/swww) &#8594; Wallpaper utility
- [wofi](https://hg.sr.ht/~scoopta/wofi) &#8594; Launcher and dmenu
- [swaync](https://github.com/ErikReider/SwayNotificationCenter) &#8594; Notification daemon
- [nvim](https://neovim.io/) &#8594; Text editor with configuration based on [astronvim](https://astronvim.com/)

#### Panel Bar & OSD

- [eww (ElKowar's Wacky Widgets)](https://elkowar.github.io/eww/) &#8594; Widget system

> [!NOTE]
> Since there are usually some problems when building `eww`, I recommend you adding [Choatic-AUR](https://aur.chaotic.cx/) for faster installation without build.

Dependencies:

```
jq socat ncmpcpp grim slurp swaync mpc libnotify upower brightnessctl wireplumber
```

#### File manager

- [lf](https://github.com/gokcehan/lf) &#8594; TUI file manager based on Vim

| Mimetype    | Previewer                |
| :---------- | :----------------------- |
| `text/*`    | `bat`                    |
| `image/svg` | `librsvg`, `imagemagick` |
| `image/*`   | `imagemagick`            |
| `video/*`   | `ffmpegthumbnailer`      |
| `audio/*`   | `exiftool`               |
| `*/pdf`     | `poppler`, `ghostscript` |

#### Music player

- [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp) &#8594; TUI music player on top of [mpd](https://github.com/MusicPlayerDaemon/MPD)
- [sptlrx](https://github.com/raitonoberu/sptlrx) &#8594; Synced lyrics fetch and display tool

#### PDF viewer

- [zathura](https://github.com/pwmt/zathura) with `zathura-pdf-poppler` or `zathura-pdf-mupdf` engine

### Scripts

- [blurframe.sh](.local/bin/blurframe.sh) &#8594; Generate a blurry frame for images with [imagemagick](https://imagemagick.org/i)
- [grimmor](.local/bin/grimmor) &#8594; Combined `blurframe.sh` with [grimblast](https://github.com/hyprwm/contrib/blob/main/grimblast/grimblast)
- [osdslider](.local/bin/osdslider) &#8594; Manage volume and brightness integrated with `eww` as OSD
- [osdmusic](.local/bin/osdmusic) &#8594; Show/hide music widget
- [screenrec](.local/bin/screenrec) &#8594; Screen record using wf-recorder integrated with `eww`
- [setwallpaper.sh](.local/bin/setwallpaper.sh) &#8594; Set wallpaper for hyprlock and `swww` with <kbd>Shift+w</kbd> in `lf`
- [thumbnailer](.local/bin/thumbnailer) &#8594; Generate thumbnails for different media used for `lf`
- [x](.local/bin/x) &#8594; Extract archive files for `lf`
- [screentools.sh](.local/bin/screentools.sh) &#8594; Screen record, magnifier, colorpicher, etc
- [fetch](.local/bin/fetch) and [unix](.local/bin/unix) &#8594; Just for the glitter XD

- #### Fish functions
  - [aur](.config/fish/functions/aur.fish)/[ins](.config/fish/functions/ins.fish) &#8594; Install packages from AUR or repo with `fzf`
  - [rem](.config/fish/functions/rem.fish)/[reml](.config/fish/functions/reml.fish) &#8594; Uninstall packeges with `fzf`
  - [dl](.config/fish/functions/dl.fish) &#8594; Use inhibitor and aria2 to download
  - [ts](.config/fish/functions/ts.fish) &#8594; Get `srt` files from SSA type subtitles
  - [scred](.config/fish/functions/scred.fish) &#8594; Edit scripts in `$EDITOR`
