# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  nixpkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."vm.swappiness" = 20;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  services.upower.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8"; i18n.extraLocaleSettings = {
    LC_TIME = "C.UTF-8"; # 24-Hour time
  };

  # set tty font
  console = {
    earlySetup = true;
    font = "ter-i16n";
    packages = [ pkgs.terminus_font ];
    keyMap = "us";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "chili";
  };

  # Enable Hyprland window manager
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = false;
    pulse.enable = true;
    jack.enable = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pxeemo = {
    isNormalUser = true;
    description = "pxeemo";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;
  programs.fish.enable = true;

  security.polkit.enable = true;

  # # allow running binaries
  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   # Add any missing dynamic libraries for unpackaged programs
  #   # here, NOT in environment.systemPackages
  #   jdk21
  #   xorg.libXext 
  #   xorg.libXtst 
  #   xorg.libXrender
  #   xorg.libX11
  #   xorg.libXi
  # ];
  
  environment.localBinInPath = true;
  environment.systemPackages = with pkgs; [
    git
    clang
    nekoray
    file jq bc
    socat
    librsvg ghostscript imagemagick
    ffmpeg ffmpegthumbnailer
    libnotify
    wl-clipboard
    brightnessctl
    p7zip unzip
    pandoc
    playerctl
    #networkmanagerapplet
    nitch fastfetch
    nh nix-output-monitor nvd
    sddm-chili-theme
    niri

    nixpkgs-unstable.hyprlandPlugins.hyprscroller
    ntfs3g dosfstools
  ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # services.mysql = {
  #   enable = true;
  #   package = pkgs.mariadb;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
