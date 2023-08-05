{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TLS Certificates
    cacert

    # fonts
    (nerdfonts.override { fonts = [ "Hasklig" ]; })

    # tools
    ffmpeg
    graphviz
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
    visidata

    # nix
    nix-du

    # silly
    cowsay
    neofetch
  ];
}
