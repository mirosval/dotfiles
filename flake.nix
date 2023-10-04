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
    in
    {
      nixosConfigurations.jimmy = nixpkgs-unstable.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ({ config, ... }: {
            config.system.stateVersion = "23.05";
          })
          ./hosts/jimmy
        ];
        specialArgs = { inherit inputs nixpkgs; };
      };
      nixosConfigurations.leon = nixpkgs-unstable.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ({ config, ... }: {
            config.system.stateVersion = "23.05";
          })
          ./hosts/leon
        ];
        specialArgs = { inherit inputs nixpkgs; };
      };
      nixosConfigurations.butters = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit hyprland; };
        modules = [
          ({ config, ... }: {
            config.system.stateVersion = "23.11";
          })
          ./hosts/butters/configuration.nix
          hyprland.nixosModules.default
          ./hosts/butters/services
          agenix.nixosModules.default
          secrets.nixosModules.secrets
          {
            secrets.enable = true;
          }
          home-manager.nixosModules.home-manager
          {
            users.users.miro.home = "/home/miro";
            home-manager.users.miro = {
              imports = homeManagerConfig.imports ++ [
                hyprland.homeManagerModules.default
                ./modules/hyprland
              ];
            };
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
        specialArgs = { inherit inputs nixpkgs; };
      };
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
      darwinConfigurations.jimbo = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/jimbo/default.nix
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
