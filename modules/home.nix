{pkgs, ...}: {
  home.username = "mirosval";
  home.homeDirectory = "/Users/mirosval";
  home.packages = [
    pkgs.cowsay
  ];
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
