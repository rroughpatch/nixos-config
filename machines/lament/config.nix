{ config, pkgs, ... }: {

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1u" "python-2.7.18.6" ];

  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "lament";
    firewall.enable = true;
    networkmanager.enable = true;
    enableIPv6 = true;
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
  };

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    useXkbConfig = true;
  };

  services = {
    printing.enable = true;
    flatpak.enable = true;
    dbus.enable = true;
    
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

  security.rtkit.enable = true;

  # Enable sound.
  sound.enable = true;

  users.users.rain = {
    isNormalUser = true;
    description = "rain";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment = {
    sessionVariables = {
      #if cursor invis
      WLR_NO_HARDWARE_CURSORS = "1";
      #electron helper
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [
      wget
      vim
      vscode
      neofetch
      neovim
      autojump
      starship
      brave
      brightnessctl
      bspwm
      cargo
      discord
      mako
      eww
      feh
      fontconfig
      freetype
      grim
      gh
      gimp
      git
      kitty
      libnotify
      lutris
      nerdfonts
      networkmanagerapplet
      nodejs
      nomacs
      python3Full
      python.pkgs.pip
      ripgrep
      rofi-wayland
      sassc
      slurp
      swww
      spotify
      steam
      terminus_font
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      wireplumber
      wl-clipboard
      xdg-desktop-portal-hyprland

    ];
  };

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    nvidiaPatches = true;
  };

  virtualisation.libvirtd.enable = true;

  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

 

  system = {
    stateVersion = "23.05";
    copySystemConfiguration = true;
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
  };
}
