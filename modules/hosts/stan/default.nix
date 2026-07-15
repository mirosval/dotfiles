{
  self,
  inputs,
  config,
  ...
}:
{
  flake.nixosConfigurations.stan = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.stanConfiguration
      self.nixosModules.steam
      self.nixosModules.fonts
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.llama
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.users.miro = config.homeConfig;
      }
    ];
  };
}
