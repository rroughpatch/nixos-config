{
  lib,
  inputs,
  system,
  config,
  pkgs,

  username,
  fullname,
  ...
}:

{
  imports = [
    ./appimage.nix
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Time Zone
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1u" "python-2.7.18.6" ];

  # networking = {
  #   hostName = "lament";
  #   firewall.enable = true;
  #   networkmanager.enable = true;
  #   enableIPv6 = true;
  #   # firewall.allowedTCPPorts = [ ... ];
  #   # firewall.allowedUDPPorts = [ ... ];
  # };

  users.users.rain = {
    isNormalUser = true;
    description = "rain";
    extraGroups = [ "networkmanager" "wheel" "kvm"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:

  environment = {
    sessionVariables = {
      # if cursor invis
      WLR_NO_HARDWARE_CURSORS = "1";
      # electron helper
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = with pkgs; [
      #### Core Packages
      brightnessctl
      clang
      gcc
      glibc
      libnotify
      pipewire
      procps
      unzip
      wireplumber
      wget
      xdg-desktop-portal-hyprland
      xdg-utils
      zip
      wl-clipboard

      #### Standard Packages
      networkmanager
      networkmanagerapplet
      git
      vim
      vscode

      #### My Packages

      neofetch
      autojump
      starship
      brave
      mpv
      bat
      feh
      fontconfig
      freetype
      grim
      gh
      gimp
      kitty
      lutris
      nerdfonts
      nomacs
      python3Full
      python.pkgs.pip
      ripgrep
      sassc
      slurp
      
      #### Proprietary Packages
      spotify
      steam
      discord

      #### Hyprland Rice
      swww
      mako
      rofi-wayland
      terminus_font
      eww-wayland
      bspwm
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))

    #### Programming Languages
    ## JavaScript
    nodejs
    ## Rust
    cargo
    rustc
    rust-analyzer
    ## Go
    go

    ];
  };

  # Font stuff:
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  services = {
    flatpak.enable = true;
    
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia"];
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal
  '';


  # Enable sound.
  sound.enable = true;

  ## Enable shit:
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    nvidiaPatches = true;
    hidpi = true;
  };

  # Steam
  programs.steam.enable = true;

  virtualisation.libvirtd.enable = true;



  home-manager.users.${username} = {
  programs.waybar = {
    enable = true;
    package = inputs.hyprland.packages.${system}.waybar-hyprland;
  };
};


  # Package overlays:
  nixpkgs.overlays = [
    (self: super: {
    })
  ];


  system = {
    stateVersion = "23.05"; # Did you read the comment?
    copySystemConfiguration = true;
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
  };
}
