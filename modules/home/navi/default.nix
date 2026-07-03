{ ... }: {
  homeModules.navi = { pkgs-unstable, ... }: {
    home.packages = [ pkgs-unstable.navi ];
    xdg.configFile = {
      "navi/config.yaml".source = ./config.yaml;
      "navi/cheats/common.cheat".source = ./cheats/common.cheat;
    };
  };
}
