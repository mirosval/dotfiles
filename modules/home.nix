{pkgs, ...}: {
  home.username = "mirosval";
  home.homeDirectory = "/Users/mirosval";
  home.stateVersion = "23.05";

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };
}
