{pkgs, ...}: {
  home.username = "mirosval";
  home.homeDirectory = "/Users/mirosval";
  home.stateVersion = "23.05";
  home.enableNixpkgsReleaseCheck = true;

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    home-manager.enable = true;
  };
}
