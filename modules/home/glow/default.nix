{ ... }: {
  homeModules.glow = { pkgs, pkgs-unstable, ... }: {
    home.packages = [ pkgs-unstable.glow ];
    home.file."Library/Preferences/glow/glow.yml".source = ./glow.yml;
  };
}
