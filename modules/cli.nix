{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # tools
    jq
    sd
    tokei
    wget

    # terminal
    bat
    direnv
    exa
    starship
    tree
    zsh-syntax-highlighting

    # silly
    cowsay
    neofetch
  ];
}
