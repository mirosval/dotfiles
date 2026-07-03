{ ... }: {
  flake.nixosModules.steam = {
    programs.steam.enable = true;
  };
}
