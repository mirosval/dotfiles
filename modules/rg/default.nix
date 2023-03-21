{ pkgs, ... }:
{
  xdg.configFile = {
    "rg/rgrc".source = ./rgrc;
  }
}
