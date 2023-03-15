{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    xdg.configFile = {
      "nvim/lua" = {
        source = ./lua;
        recursive = true;
      };
      "nvim/init_lua.lua".source = ./init.lua;
    };
  };
}
