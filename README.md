<h1 align="center">Dotfiles of <a href="https://github.com/pxeemo">pxeemo</a>!</h1>
<p align="center">My Linux distribution configuration files</p>

## Hyprland:

![shot1](screenshots/view.avif)

### See [Catppuccin](https://catppuccin-website.vercel.app/) for GTK & QT themes

# Installation

Needed `git` to clone this repo and `stow` to manage dotfiles:

```shell
git clone --depth=1 https://github,com/pxeemo/workflow.git
cd workflow
stow .
```

## Used Apps

#### Terminal

- [kitty](https://github.com/kovidgoyal/kitty) &#8594; Terminal emulator

#### Panel Bar & OSD:

> [!NOTE]
> Since there are usually some problems when building `eww`, I recommend you adding [Choatic-AUR](https://aur.chaotic.cx/) for faster installation without build.

- [eww (ElKowar's Wacky Widgets)](https://elkowar.github.io/eww/) &#8594; Widget system

Dependencies:
```
jq socat ncmpcpp grim slurp swaync mpc libnotify upower brightnessctl wireplumber
```

#### File manager

- [lf](https://github.com/gokcehan/lf) &#8594; TUI file manager based on Vim

| Mimetype    | Previewer                |
| :---------- | :------------------------ |
| `text/*`    | `bat`                     |
| `image/svg` | `librsvg`, `imagemagick`  |
| `image/*`   | `imagemagick`             |
| `video/*`   | `ffmpegthumbnailer`       |
| `audio/*`   | `exiftool`                |
| `*/pdf`     | `poppler`, `ghostscript`  |

#### Music player

- [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp) &#8594; TUI music player on top of [mpd](https://github.com/MusicPlayerDaemon/MPD)
- [sptlrx](https://github.com/raitonoberu/sptlrx) &#8594; Synced lyrics fetch and display tool

#### PDF viewer

- [zathura](https://github.com/pwmt/zathura) with `zathura-pdf-poppler` or `zathura-pdf-mupdf` engine
