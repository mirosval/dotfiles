{ ... }: {
  homeModules.cli = { pkgs, pkgs-unstable, ... }: {
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
