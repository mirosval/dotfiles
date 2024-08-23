{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # TLS Certificates
    cacert

    # fonts
    (unstable.nerdfonts.override { fonts = [ "Hasklig" "Monaspace" ]; })

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
    tree
    unstable.difftastic
    unstable.eza
    unstable.srgn
    unstable.tailscale
    zsh-syntax-highlighting

    # nix
    # nix-du

    # silly
    cowsay
    neofetch
  ];
}
