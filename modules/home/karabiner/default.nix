{ ... }: {
  homeModules.karabiner = { lib, pkgs, ... }: lib.mkIf pkgs.stdenv.isDarwin {
    xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
  };
}
