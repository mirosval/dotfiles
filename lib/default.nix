{ nixpkgs, nixpkgs-unstable, stateVersion, inputs, darwin, home-manager, hyprland, secrets, agenix }:
let
  homeManagerConfig = import ../home {
    pkgs = nixpkgs;
    inherit inputs;
  };
in
{
  homeConfiguration = { system, user }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        ../home
        {
          home.username = user;
          home.homeDirectory = "/Users/${user}";
        }
      ];
      extraSpecialArgs = {
        inherit inputs;
      };
    };

  raspberryImage = { host }:
    nixpkgs-unstable.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ({ config, ... }: {
          config.system.stateVersion = stateVersion;
        })
        (../hosts + "/${host}")
      ];
      specialArgs = { inherit inputs; };
    };

  darwinSystem = { host, user }:
    darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        (../hosts + "/${user}")
        home-manager.darwinModules.home-manager
        {
          users.users."${user}".home = "/Users/${user}";
          home-manager.users."${user}" = homeManagerConfig;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };

  linuxSystem = { host, user }:
    nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit hyprland; };
      modules = [
        ({ config, ... }: {
          config.system.stateVersion = "23.11";
        })
        (../hosts + "/${host}/configuration.nix")
        hyprland.nixosModules.default
        (../hosts + "/${host}/services")
        agenix.nixosModules.default
        secrets.nixosModules.secrets
        {
          secrets.enable = true;
        }
        home-manager.nixosModules.home-manager
        {
          users.users."${user}".home = "/home/${user}";
          home-manager.users."${user}" = homeManagerConfig // {
            imports = [
              hyprland.homeManagerModules.default
              ../home/hyprland
            ];
          };
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
      specialArgs = { inherit inputs; };
    };

}
