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
    unstable.nerd-fonts.hasklug
    unstable.nerd-fonts.monaspace

    # tools
    bonk
    dig
    ffmpeg
    graphviz
    jq
    sd
    tokei
    unstable.colima
    unstable.docker
    unstable.docker-buildx
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

    # AI
    unstable.goose-cli
  ];
}
