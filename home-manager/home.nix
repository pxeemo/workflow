{ inputs, config, pkgs, ... }:

let
  outfit-fonts = import ./outfit-fonts.nix { inherit pkgs; };
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  mypython = (pkgs.python312.withPackages (pythonPackages: with pythonPackages; [
        pip
        ipython
        dbus-python
        pygobject3
  ]));
in 
{
  # add the home manager module
  # imports = [ ];
  nixpkgs.overlays = [ inputs.polymc.overlay ];

  home.username = "pxeemo";
  home.homeDirectory = "/home/pxeemo";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    libsForQt5.qtstyleplugins
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
    (catppuccin-kvantum.override { accent = "Blue"; variant = "Mocha"; })

    fira-code
    vazir-fonts
    vazir-code-font
    (nerdfonts.override { fonts = [ "JetBrainsMono" "UbuntuMono" ]; })

    # hyprcursor
    hyprpicker
    # hyprutils
    # hyprlang

    polymc
    inkscape
    fribidi
    sxiv
    gedit
    telegram-desktop
    mpc-cli
    jcal
    dunst
    zbar
    grim
    slurp
    nwg-drawer
    nwg-look
    duf # better df
    cliphist
    trash-cli

    android-tools
    scrcpy

    mypython
    # python312Packages.pip
    # python312Packages.ipython
    # python312Packages.python-lsp-server
    # python312Packages.dbus-python 
    # python312Packages.pygobject3
    # (import ./eww/scripts/notification-daemon.nix { inherit pkgs; })
    # (import ./c.nix { inherit pkgs; })
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.catppuccin-cursors.mochaBlue;
    name = "catppuccin-mocha-blue-cursors";
    size = 32;
  };
  home.sessionVariables = {
    PAGER = "bat";
    MANPAGER = "nvim +Man!";
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif =     [ "Vazirmatn" ];
      sansSerif = [ "Vazirmatn" ];
      emoji =     [ "Joypixels" ];
      monospace = [ "JetBrainsMonoNL" "vazir-code" ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hypr/hyprland.conf;
  };
  programs.hyprlock.enable = true;
  programs.hyprlock.extraConfig = builtins.readFile ./hypr/hyprlock.conf;
  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "brightnessctl -r; hyprctl dispatch dpms on";
    };
    listener = [
      {
        timeout = 160;
        on-timeout = "brightnessctl -s set 3%";
        on-resume = "brightnessctl -r";
      }
      {
        timeout = 300;
        on-timeout = "loginctl lock-session";
      }
      {
        timeout = 600;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 1200;
        on-timeout = "systemctl suspend";
      }
    ];
  };
  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    ipc = "on";
    splash = true;
    splash_offset = 2.0;
    preload = [ "${config.xdg.configHome}/home-manager/hypr/wallpaper.webp" ];
    wallpaper = [ ",${config.xdg.configHome}/home-manager/hypr/wallpaper.webp" ];
  };

  xdg.configFile = {
    "hypr/gamemode.sh".source = ./hypr/gamemode.sh;
    "lf/colors".source = ./lf/colors;
    "lf/icons".source = ./lf/icons;
    "lf/lf_kitty_clean".source = ./lf/lf_kitty_clean;
    "lf/lf_kitty_preview".source = ./lf/lf_kitty_preview;
    "nwg-drawer/drawer.css".source = ./nwg-drawer/drawer.css;
    "xkb".source = ./xkb;
    "dunst".source = ./dunst;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" "org.pwmt.zathura-pdf-poppler.desktop" ];
      "text/plain" = [ "neovim.desktop" ];
      "inode/directory" = [ "lf.desktop" "kitty-open.desktop" ];
      "image/*" = [ "vimiv.desktop" "sxiv.desktop" ];
      "video/*" = [ "mpv.desktop" ];
      "audio/*" = [ "mpv.desktop" ];
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    publicShare = null;
    desktop =   "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/doc";
    download =  "${config.home.homeDirectory}/dls";
    music =     "${config.home.homeDirectory}/mus";
    pictures =  "${config.home.homeDirectory}/pic";
    templates = "${config.home.homeDirectory}/tmp";
    videos =    "${config.home.homeDirectory}/vid";
    extraConfig = {
      XDG_SCREENSHOT_DIR = "${config.xdg.userDirs.pictures}/scr";
      XDG_SCREENREC_DIR = "${config.xdg.userDirs.videos}/scr";
    };
  };

  services.mpd.enable = true;
  services.mpd.extraConfig = ''
    audio_output {
      type    "pipewire"
      name    "Pipewire Sound Server"
    }
    audio_output {
      type    "fifo"
      name    "my_fifo"
      path    "/tmp/mpd.fifo"
      format  "44100:16:2"
    }
  '';
  services.mpdris2.enable = true;
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    bindings = [
    { key = "k"; command = "scroll_up"; }
    { key = "K"; command = [ "select_item" "scroll_up" ]; }
    { key = "j"; command = "scroll_down"; }
    { key = "J"; command = [ "select_item" "scroll_down" ]; }
    { key = "D"; command = [ "delete_playlist_items" "delete_browser_items" "delete_stored_playlist" ]; }
    { key = "l"; command = [ "next_column" "slave_screen" ]; }
    { key = "h"; command = [ "previous_column" "master_screen" "seek_backward" ]; }
    { key = "l"; command = "seek_forward"; }
    { key = "f"; command = "show_lyrics"; }
    { key = "0"; command = "volume_up"; }
    { key = "9"; command = "volume_down"; }
    ];
    settings = {
      ncmpcpp_directory = "${config.xdg.dataHome}/ncmpcpp";
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "ellipse";
      visualizer_look = "▋▋";
      visualizer_color = "100, 94, 93, 92, 91, 90, 89";
      browser_sort_mode = "mtime";
      execute_on_song_change = "songinfo";
      progressbar_look = "=>-";
      user_interface = "alternative";
      follow_now_playing_lyrics = "yes";
      allow_for_physical_item_deletion = "yes";
      mouse_support = "yes";
      external_editor = "nvim";
      colors_enabled = "yes";
      volume_color = "119";
      state_line_color = "cyan";
      main_window_color = "cyan";
      color1 = "cyan";
      color2 = "blue";
      progressbar_color = "white";
      progressbar_elapsed_color = "blue:b";
      window_border_color = "cyan";
      active_window_border = "red";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.kitty = {
    enable = true;
    package = unstable.kitty;
    extraConfig = ''
      ${builtins.readFile ./kitty/my_colors.conf}
      ${builtins.readFile ./kitty/kitty.conf}
      bell_path ${./kitty/mixkit-sci-fi-click-900.wav}
    '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-blue-standard";
      package = (pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        variant = "mocha";
      });
    };
    cursorTheme = {
      name = "catppuccin-mocha-blue-cursors";
      package = pkgs.catppuccin-cursors.mochaBlue;
      size = 32;
    };
    iconTheme = {
      name = "Reversal-dark";
      package = pkgs.reversal-icon-theme;
    };
    font = {
      name = "Outfit";
      package = outfit-fonts;
      size = 11;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.git = {
    enable = true;
    userName = "pxeemo";
    userEmail = "shayans31516@gmail.com";
  };

  programs.eww = {
    enable = true;
    configDir = ./eww;
  };

  programs.zathura = {
    enable = true;
    # package = pkgs.zathura.override { useMupdf = false; };
    extraConfig = ''
    ${builtins.readFile ./zathura/catppuccin-mocha}
    ${builtins.readFile ./zathura/zathurarc}
    '';
  };

  programs.lf = {
    enable = true;
    commands = {
      trash = "%${pkgs.trash-cli}/bin/trash-put $fx";
    };
    keybindings = {
      gd = "cd ${config.xdg.userDirs.download}";
      gt = "cd ${config.xdg.dataHome}/Trash";
      gr = "cd /run/media/${config.home.username}";
    };
    extraConfig = ''
    ${builtins.readFile ./lf/lfrc}
    setlocal ${config.xdg.dataHome}/Trash sortby time
    setlocal ${config.xdg.dataHome}/Trash reverse
    setlocal ${config.xdg.userDirs.download}/ sortby time
    setlocal ${config.xdg.userDirs.download}/ reverse
    '';
  };

  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      allow_markup = true;
      gtk_dark = true;
      hide_scroll = true;
      image_size = 48;
      insensitive = true;
      line_wrap = "word";
      matching = "fuzzy";
      mode = "run";
      prompt = "Search";
      term = "kitty";
    };
    style = builtins.readFile ./wofi/style.css;
  };

  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "${pkgs.pokemon-colorscripts-mac}/bin/pokemon-colorscripts -r";
      lf = ''
        set last_dir (command lf -print-last-dir $argv)
        if test -n $last_dir
            cd $last_dir
        end
      '';
      screen-rec = ''
        set -l adev (wpctl inspect @DEFAULT_AUDIO_SINK@ | awk -F'"' '/node.name/{print $2}')
        test -d $XDG_SCREENREC_DIR; or mkdir -p $XDG_SCREENREC_DIR
        cd $XDG_SCREENREC_DIR
        ${pkgs.wf-recorder}/bin/wf-recorder \
            --audio=$adev.monitor \
            --pixel-format=yuv420p \
            -f (date +%s).mkv
        prevd
      '';
      scred = {
        description = "edit scripts";
        wraps = "${config.home.homeDirectory}/.local/bin/";
        body = "$EDITOR (which $argv)";
      };
      ffasrt = {
        description = "format farsi srt";
        body = ''
          for file in $argv
            if ! head -30 $file | grep -q '[آ-ی]'
              python -c "
        with open('$file', 'r', encoding='cp1256') as f:
            content = f.read()
        with open('$file', 'w', encoding='utf-8') as f:
            f.write(content)"
              and echo "Re-encoded."
            end

            sed -i -E \
              -e 's/ face="[^"]+"//g' \
              -e 's/ size="[0-9]+"//g' \
              -e 's/ي/ی/g' \
              -e 's/ك/ک/g' \
              -e 's/ه[ ‌]ی([^آ-ی]|$)/ۀ\1/g' \
              -e 's/ه ای([^آ-ی]|$)/ه‌ای\1/g' \
              $file
            echo $file
          end
        '';
      };
      ts = {
        description = "convert mkv and ass to srt";
        body = ''
          set _flag_max 0 # subtitle stream index
          argparse "#max" -- $argv
          for org in $argv
            set -l srt (path change-extension srt $org)
            ${pkgs.ffmpeg}/bin/ffmpeg -i $org -map 0:s:$_flag_max $srt

            ffasrt $srt
          end
        '';
      };
      webcam = "${pkgs.mpv}/bin/mpv --vf=hflip --profile=low-latency --untimed av://v4l2:/dev/video0 $argv";
    };
    shellAbbrs = {
      runat = "systemd-run --user --on-calendar";
      runafter = "systemd-run --user --on-active";
      ns = "nom-shell --command fish -p";
      oss = "nh os switch /etc/nixos/";
      hms = "nh home switch ~/.config/home-manager/";
    };
    shellAliases = {
      ls = "${pkgs.eza}/bin/eza --almost-all --long --classify --icons --git --sort=type --time-style=relative";
      dl = "${pkgs.aria2}/bin/aria2c --max-concurrent-downloads=2 --split=8 --max-tries=0 --continue";
      icat = "${pkgs.kitty}/bin/kitten icat";
      mkcd = "mkdir -p $argv && cd $argv[-1]";
    };
  };

  programs.eza.enable = true;
  programs.zoxide.enable = true;
  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
  };
  programs.bat.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
