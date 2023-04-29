{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TLS Certificates
    cacert

    # fonts
    (nerdfonts.override { fonts = [ "Hasklig" ]; })

    # tools
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

    # nix
    nix-du

    # silly
    cowsay
    neofetch
  ];
}
