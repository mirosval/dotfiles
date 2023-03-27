{
  description = "Miro's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: rec {
    overlays = {
      libtmux = import ./overlays/libtmux.nix;
    };
    home-common = {lib, ...}: {
      nixpkgs.overlays = [
        overlays.libtmux
      ];
      programs.home-manager.enable = true;
      imports = [
        ./modules/cli.nix
        ./modules/direnv
        ./modules/fd
        ./modules/home.nix
        ./modules/nvim
        ./modules/rg
        ./modules/starship
        ./modules/tmux
        ./modules/zoxide
        ./modules/zsh
      ];
    };
    system = "aarch64-darwin";
    defaultPackage.${system} = home-manager.defaultPackage.${system};
    homeConfigurations = {
      "mirosval" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          home-common
        ];
      };
    };
  };
}
