{ self, inputs, config, ... }: {
  flake.nixosConfigurations.stan = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.stanConfiguration
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.users.miro = config.homeConfig;
      }
    ];
  };
}
