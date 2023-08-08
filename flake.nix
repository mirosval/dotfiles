{
  description = "Miro's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, ... }:
    let
      overlays = {
        libtmux = import ./overlays/libtmux.nix;
      };
      nixpkgs = with inputs; {
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
          }
        ];
      };
    };
}
