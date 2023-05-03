{ pkgs, ... }:
{
  home.file = {
    ".hammerspoon/init.lua".source = ./init.lua;
    ".hammerspoon/Spoons" = {
      source = ./Spoons;
      recursive = true;
    };
  };
}
