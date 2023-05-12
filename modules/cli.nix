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
    tree
    zsh-syntax-highlighting

    # nix
    nix-du

    # silly
    cowsay
    neofetch
  ];
}
