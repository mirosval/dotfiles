{
  description = "Miro's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      # This pattern is because the repo is private
      # it relies on git being configured with gh auth setup-git
      url = "git+https://github.com/mirosval/secrets.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blocklist = {
      url = "github:mirosval/unbound-blocklist";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, darwin, agenix, secrets, ... }:
    let
      stateVersion = "23.05";
      lib = import ./lib {
        inherit nixpkgs nixpkgs-unstable stateVersion inputs darwin home-manager home-manager-unstable secrets agenix;
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
        };
        leon = lib.raspberryImage {
          system = "aarch64-linux";
          host = "leon";
          user = "miro";
        };
        butters = lib.linuxSystem {
          system = "x86_64-linux";
          host = "butters";
          user = "miro";
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
    };
}
