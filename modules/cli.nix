{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
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
    unstable.eza
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
