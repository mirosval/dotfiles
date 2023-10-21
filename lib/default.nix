{ nixpkgs, nixpkgs-unstable, stateVersion, inputs, darwin, home-manager, home-manager-unstable, secrets, agenix, blocklist }:
let
  homeManagerConfig = import ../home {
    pkgs = nixpkgs;
    inherit inputs;
  };
in
{
  homeConfiguration = { system, host, user }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
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

  raspberryImage = { system, host, user }:
    nixpkgs-unstable.lib.nixosSystem {
      inherit system;
      modules = [
        "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ({ config, ... }: {
          config.system.stateVersion = stateVersion;
        })
        (../hosts + "/${host}")
      ];
      specialArgs = { inherit inputs; };
    };

  darwinSystem = { system, host, user }:
    darwin.lib.darwinSystem {
      inherit system;
      modules = [
        (../hosts + "/${user}")
        home-manager.darwinModules.home-manager
        {
          users.users."${user}".home = "/Users/${user}";
          home-manager.users."${user}" = homeManagerConfig;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            pkgs = import nixpkgs { inherit system; };
          };
        }
      ];
    };

  linuxSystem = { system, host, user }:
    nixpkgs-unstable.lib.nixosSystem {
      inherit system;
      modules = [
        ({ config, ... }: {
          config.system.stateVersion = "23.11";
        })
        (../hosts + "/${host}/configuration.nix")
        (../hosts + "/${host}/services")
        agenix.nixosModules.default
        secrets.nixosModules.secrets
        {
          secrets.enable = true;
        }
        home-manager-unstable.nixosModules.home-manager
        {
          users.users."${user}".home = "/home/${user}";
          home-manager.users."${user}" = homeManagerConfig;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            pkgs = import nixpkgs-unstable { inherit system; };
          };
        }
      ];
      specialArgs = { inherit inputs; };
    };

}
