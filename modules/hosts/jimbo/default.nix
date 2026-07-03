{ inputs, config, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "aarch64-darwin";
    config.allowUnfree = true;
  };
in
{
  flake.darwinConfigurations.jimbo = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      config.darwinModules.shared
      inputs.home-manager.darwinModules.home-manager
      {
        networking.computerName = "Miroslavs Work MBP";
        networking.hostName = "miroslavs-work-mbp";
        networking.localHostName = "miroslavs-work-mbp";
        ids.gids.nixbld = 30000;
        users.users.mirosval = {
          name = "mirosval";
          home = "/Users/mirosval";
        };
        # homebrew = { enable = true; brews = []; casks = [ ... ]; };
        # Disabled: macOS 26.x is unsupported by Homebrew
        home-manager.useGlobalPkgs = true;
        home-manager.users.mirosval = config.homeConfig;
        home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
      }
    ];
  };
}
