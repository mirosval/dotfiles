{ ... }: {
  homeModules.hammerspoon = { lib, pkgs, ... }: lib.mkIf pkgs.stdenv.isDarwin {
    home.file = {
      ".hammerspoon/init.lua".source = ./init.lua;
      ".hammerspoon/Spoons" = {
        source = ./Spoons;
        recursive = true;
      };
    };
  };
}
