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
    hyprland.url = "github:hyprwm/Hyprland";
    # This pattern is because the repo is private
    # it relies on git being configured with gh auth setup-git
    secrets.url = "git+https://github.com/mirosval/secrets.git?ref=main";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, darwin, hyprland, agenix, secrets, ... }:
    let
      stateVersion = "23.05";
      overlays = {
        libtmux = import ./overlays/libtmux.nix;
      };
      lib = import ./lib {
        inherit nixpkgs nixpkgs-unstable stateVersion inputs darwin home-manager hyprland secrets agenix;
      };
    in
    {
      homeConfigurations.jimbo = lib.homeConfiguration {
        system = "aarch64-darwin";
        user = "mirosval";
      };
      nixosConfigurations.jimmy = lib.raspberryImage {
        host = "jimmy";
      };
      nixosConfigurations.leon = lib.raspberryImage {
        host = "leon";
      };
      nixosConfigurations.butters = lib.linuxSystem {
        host = "butters";
        user = "miro";
      };
      darwinConfigurations.mirosval = lib.darwinSystem {
        host = "Miro Home MBP";
        user = "mirosval";
      };
      darwinConfigurations.jimbo = lib.darwinSystem {
        host = "Miro Work MBP";
        user = "mirosval";
      };
    };
}
