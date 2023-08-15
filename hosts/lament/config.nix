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
  networking = { hostName = "lament"; };

  # GPU Drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  programs.hyprland.nvidiaPatches = true;
}
