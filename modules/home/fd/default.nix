{ ... }: {
  homeModules.fd = { pkgs, ... }: {
    home.packages = [ pkgs.fd ];
    xdg.configFile."fd/ignore".source = ./ignore;
  };
}
