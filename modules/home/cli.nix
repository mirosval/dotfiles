{ ... }: {
  homeModules.cli =
    { pkgs, pkgs-unstable, ... }:
    let
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
        cacert
        pkgs-unstable.nerd-fonts.hasklug
        pkgs-unstable.nerd-fonts.monaspace
        bonk
        dig
        dust
        ffmpeg
        graphviz
        jq
        sd
        tokei
        pkgs-unstable.colima
        pkgs-unstable.docker
        pkgs-unstable.docker-buildx
        pkgs-unstable.trippy
        wget
        bat
        tree
        tuicr
        pkgs-unstable.bandwhich
        pkgs-unstable.bottom
        pkgs-unstable.btop
        pkgs-unstable.difftastic
        pkgs-unstable.eza
        pkgs-unstable.procs
        pkgs-unstable.rink
        pkgs-unstable.srgn
        pkgs-unstable.tailscale
        zsh-syntax-highlighting
        pkgs-unstable.codex
      ];
    };
}
