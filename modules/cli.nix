{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # fonts
    nerdfonts

    # tools
    jq
    sd
    tokei
    wget

    # terminal
    bat
    exa
    starship
    tree
    zsh-syntax-highlighting

    # silly
    cowsay
    neofetch
  ];
}
