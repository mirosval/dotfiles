{ inputs, config, ... }: {
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
        home-manager.useGlobalPkgs = true;
        home-manager.users.mirosval = config.homeConfig;
        home-manager.extraSpecialArgs = { inherit inputs; };
      }
    ];
  };
}
