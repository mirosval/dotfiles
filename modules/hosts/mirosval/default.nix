{ inputs, config, ... }: {
  flake.darwinConfigurations.mirosval = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      config.darwinModules.shared
      inputs.home-manager.darwinModules.home-manager
      {
        networking.computerName = "Miro Home MBP";
        networking.hostName = "mirosval";
        users.users.mirosval = {
          name = "mirosval";
          home = "/Users/mirosval";
        };
        # homebrew.enable = true;
        # Disabled: macOS 26.x is unsupported by Homebrew (same as jimbo)
        home-manager.useGlobalPkgs = true;
        home-manager.users.mirosval = config.homeConfig;
        home-manager.extraSpecialArgs = { inherit inputs; };
      }
    ];
  };
}
