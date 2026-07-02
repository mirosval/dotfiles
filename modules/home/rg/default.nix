{ ... }: {
  homeModules.rg = { pkgs, ... }: {
    home.packages = [ pkgs.ripgrep ];
    xdg.configFile."rg/rgrc".source = ./rgrc;
  };
}
