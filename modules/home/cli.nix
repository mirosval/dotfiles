{ ... }: {
  homeModules.cli =
    { pkgs, inputs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        cacert
        unstable.nerd-fonts.hasklug
        unstable.nerd-fonts.monaspace
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
        bat
        tree
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
        unstable.codex
      ];
    };
}
