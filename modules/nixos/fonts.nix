{ ... }: {
  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts.packages = [ pkgs.nerd-fonts.symbols-only ];
  };
}
