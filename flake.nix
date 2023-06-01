{
  description = "Miro's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, darwin, ... }: rec {
    overlays = {
      libtmux = import ./overlays/libtmux.nix;
    };
    home-common = {lib, ...}: {
      nixpkgs.overlays = [
        overlays.libtmux
      ];
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
    defaultPackage.${system} = home-manager.defaultPackage.${system};
    homeConfigurations = {
      "mirosval" = home-manager.lib.homeManagerConfiguration {
        pkgs = (import nixpkgs) { inherit system; };
        modules = [
          home-common
        ];
      };
    };
  };
}
