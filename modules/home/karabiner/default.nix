{ ... }: {
  homeModules.karabiner = _: {
    xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
  };
}
