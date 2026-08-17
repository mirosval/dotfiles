{ ... }: {
  homeModules.cli = { pkgs, pkgs-unstable, ... }: {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      bat
      bonk
      cacert
      dig
      dust
      ffmpeg
      graphviz
      jq
      pkgs-unstable.bandwhich
      pkgs-unstable.bottom
      pkgs-unstable.btop
      pkgs-unstable.codex
      pkgs-unstable.colima
      pkgs-unstable.difftastic
      pkgs-unstable.docker
      pkgs-unstable.docker-buildx
      pkgs-unstable.eza
      pkgs-unstable.nerd-fonts.hasklug
      pkgs-unstable.nerd-fonts.monaspace
      pkgs-unstable.pi-coding-agent
      pkgs-unstable.procs
      pkgs-unstable.rink
      pkgs-unstable.srgn
      pkgs-unstable.tailscale
      pkgs-unstable.trippy
      pkgs-unstable.tuicr
      sd
      tokei
      tree
      wget
      zsh-syntax-highlighting
    ];
  };
}
