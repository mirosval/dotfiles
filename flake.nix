{
  description = "Miro's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, darwin, ... }: rec {
    overlays = {
      libtmux = import ./overlays/libtmux.nix;
    };
    nixpkgsConfig = {
      config = {
        allowUnfree = true;
      };
      overlays = [
        overlays.libtmux
      ];
    };
    home-common = {lib, ...}: {
      programs.home-manager.enable = true;
      imports = [
        ./modules/alacritty
        ./modules/cli.nix
        ./modules/direnv
        ./modules/fd
        ./modules/fzf
        ./modules/git
        ./modules/hammerspoon
        ./modules/home.nix
        ./modules/navi
        ./modules/nvim
        ./modules/rg
        ./modules/starship
        ./modules/tmux
        ./modules/zoxide
        ./modules/zsh
      ];
    };
    system = "aarch64-darwin";
    #defaultPackage.${system} = home-manager.defaultPackage.${system};
    #homeConfigurations = {
    #  "mirosval" = home-manager.lib.homeManagerConfiguration {
    #    pkgs = nixpkgs.legacyPackages.${system};
    #    modules = [
    #      home-common
    #    ];
    #  };
    #};
    defaultPackage.${system} = darwin.defaultPackage.${system};
    darwinConfigurations = rec {
      mirosval = darwin.lib.darwinSystem {
        system = system;
        modules = [
          {
            services.nix-daemon.enable = true;
          }
          home-manager.darwinModules.home-manager 
          {
            nixpkgs = nixpkgsConfig;
            users.users."mirosval".home = "/Users/mirosval";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."mirosval" = home-common;
            };
          }
        ];
      };
    };
  };
}
