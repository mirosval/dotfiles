{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TLS Certificates
    cacert

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

    # nix
    nix-du

    # silly
    cowsay
    neofetch
  ];
}
