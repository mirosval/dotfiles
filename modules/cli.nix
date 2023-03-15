{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # tools
    ripgrep
    sd
    bat
    jq
    tokei

    # terminal
    direnv
    starship
    zsh-syntax-highlighting

    # silly
    cowsay
    neofetch
  ];
}
