{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # tools
    ripgrep
    sd
    bat
    jq
    tokei
    wget

    # terminal
    tree
    direnv
    starship
    zsh-syntax-highlighting

    # silly
    cowsay
    neofetch
  ];
}
