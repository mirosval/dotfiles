{ self, inputs, ... }: {
  flake.nixosConfigurations.stan = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.stanConfiguration
    ];
  };
}
