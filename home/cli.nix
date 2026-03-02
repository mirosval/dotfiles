{
  pkgs,
  inputs,
  ...
}:
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
    dust
    ffmpeg
    graphviz
    jq
    sd
    tokei
    unstable.colima
    unstable.docker
    unstable.docker-buildx
    unstable.jujutsu
    unstable.trippy
    wget

    # terminal
    bat
    tree
    unstable.bandwhich
    unstable.bottom
    unstable.btop
    unstable.difftastic
    unstable.eza
    unstable.procs
    unstable.rink
    unstable.skim
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
    unstable.codex

    # Mine
    inputs.cargo-hawk.packages.${pkgs.system}.default
  ];
}
