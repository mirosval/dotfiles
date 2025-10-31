{
  description = "Miro's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blocklist = {
      url = "github:mirosval/unbound-blocklist";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      home-manager-unstable,
      darwin,
      ...
    }:
    let
      stateVersion = "24.05";
      lib = import ./lib {
        inherit
          nixpkgs
          nixpkgs-unstable
          stateVersion
          inputs
          darwin
          home-manager
          home-manager-unstable
          ;
      };
    in
    {
      homeConfigurations.jimbo = lib.homeConfiguration {
        system = "aarch64-darwin";
        host = "jimbo";
        user = "mirosval";
      };

      nixosConfigurations = {
        jimmy = lib.raspberryImage {
          system = "aarch64-linux";
          host = "jimmy";
          user = "miro";
          stateVersion = "24.05";
        };
        leon = lib.raspberryImage {
          system = "aarch64-linux";
          host = "leon";
          user = "miro";
          stateVersion = "24.05";
        };
      };

      darwinConfigurations = {
        mirosval = lib.darwinSystem {
          system = "aarch64-darwin";
          host = "mirosval";
          user = "mirosval";
        };
        jimbo = lib.darwinSystem {
          system = "aarch64-darwin";
          host = "jimbo";
          user = "mirosval";
        };
      };

      lib = {
        home = import ./home;
      };
    };
}
