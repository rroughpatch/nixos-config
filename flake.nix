{
  description = "Kerosine ";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ... 
  }: {
    nixosConfigurations = let
      fullname = "Basil";
      username = "rain";
      editor = "vscode";
      browser = "brave";
    in {
      lament = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs;
          inherit system;
          inherit username fullname;
          inherit editor browser;
        };

        modules = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = {
                home = {
                  username = username;
                  homeDirectory = "/home/${username}";
                  # do not change this value
                  stateVersion = "23.05";
                };

                # Let Home Manager install and manage itself.
                programs.home-manager.enable = true;
              };
            };
          }
          ./machines/lament/config.nix
        ];

      };
    };
  };
}

