{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fd
  ];
  xdg.configFile = {
    "fd/ignore".source = ./ignore;
  };
}
