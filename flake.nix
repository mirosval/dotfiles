{
  description = "Miro's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }:
    let
      overlays = {
        libtmux = import ./overlays/libtmux.nix;
      };
      nixpkgs = with inputs; {
        system = "aarch64-darwin";
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = [
          overlays.libtmux
        ];
      };
      homeManagerConfig = {
        imports = [
          ./modules/alacritty
          ./modules/cli.nix
          ./modules/direnv
          ./modules/fd
          ./modules/fzf
          ./modules/git
          ./modules/hammerspoon
          ./modules/home.nix
          ./modules/karabiner
          ./modules/navi
          ./modules/nvim
          ./modules/rg
          ./modules/starship
          ./modules/tmux
          ./modules/zoxide
          ./modules/zsh
        ];
      };
    in {
#      nixosConfigurations.butters = nixpkgs-unstable.lib.nixosSystem {
#        system = "aarch64-linux";
#        modules = [
#          "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
#          ({config, ...}: {
#            nixpkgs.buildPlatform = "aarch64-darwin";
#            nixpkgs.hostPlatform = "aarch64-linux";
#            #config.system.stateVersion = "23.05";
#          })
#        ];
#        specialArgs = { inherit inputs nixpkgs; };
#      };
      darwinConfigurations.mirosval = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/mirosval/default.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgs;
            users.users."mirosval".home = "/Users/mirosval";
            home-manager.useGlobalPkgs = true;
            home-manager.users.mirosval = homeManagerConfig;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
}
