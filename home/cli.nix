{
  pkgs,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  tuicr = pkgs.rustPlatform.buildRustPackage rec {
    pname = "tuicr";
    version = "0.18.0";
    src = pkgs.fetchFromGitHub {
      owner = "agavra";
      repo = "tuicr";
      rev = "v${version}";
      hash = "sha256-cMIUVBEtyS+AB9QqqRSu+Rd+9dyMzw+EmHSIzY2UmiQ=";
    };
    cargoHash = "sha256-ErEpUo9RPOHMHlmlPH2S6jHvnVhi4DKO7EnoMToj5t0=";
    doCheck = false;
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
    unstable.trippy
    wget

    # terminal
    bat
    tree
    tuicr
    unstable.bandwhich
    unstable.bottom
    unstable.btop
    unstable.difftastic
    unstable.eza
    unstable.procs
    unstable.rink
    unstable.srgn
    unstable.tailscale
    zsh-syntax-highlighting

    # nix
    # nix-du

    # AI
    unstable.codex

    # Mine
    inputs.cargo-hawk.packages.${system}.default
  ];
}
