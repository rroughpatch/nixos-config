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
    ./hardware-configuration.nix
    ./../../global.nix
  ];

  # Hostname
  networking = {
    hostName = "lament";
    firewall.enable = true;
    networkmanager.enable = true;
    enableIPv6 = true;
#   # firewall.allowedTCPPorts = [ ... ];
#   # firewall.allowedUDPPorts = [ ... ];
  };

  # GPU Drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  programs.hyprland.nvidiaPatches = true;
}
