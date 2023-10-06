{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
  ];
  xdg.configFile = {
    "rg/rgrc".source = ./rgrc;
  };
}
