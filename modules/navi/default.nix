{ pkgs, ... }:
{
  home.packages = with pkgs; [
    navi
  ];
  xdg.configFile = {
    "navi/config.yaml".source = ./config.yaml;
    "navi/cheats/common.cheat".source = ./cheats/common.cheat;
  };
}
