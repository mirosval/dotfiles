{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # TLS Certificates
    cacert

    # fonts
    (nerdfonts.override { fonts = [ "Hasklig" ]; })

    # tools
    dig
    ffmpeg
    graphviz
    jq
    sd
    tokei
    wget

    # terminal
    bat
    unstable.tailscale
    tree
    unstable.eza
    visidata
    zsh-syntax-highlighting

    # nix
    nix-du

    # silly
    cowsay
    neofetch
  ];
}
