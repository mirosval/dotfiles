{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
  };
in
{
  home.packages = [
    unstable.navi
  ];
  xdg.configFile = {
    "navi/config.yaml".source = ./config.yaml;
    "navi/cheats/common.cheat".source = ./cheats/common.cheat;
  };
}
