{
  description = "Miro's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: 
    let 
      home-common = {lib, ...}: {
          programs.home-manager.enable = true;
          imports = [
            ./modules/home.nix
            ./modules/cli.nix
            ./modules/zsh
          ];
      };
      system = "aarch64-darwin";
    in 
    {
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
