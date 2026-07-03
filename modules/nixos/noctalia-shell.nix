{ ... }: {
  flake.nixosModules.noctalia-shell = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.noctalia-shell ];
  };
}
