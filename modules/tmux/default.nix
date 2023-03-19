{ pkgs, ... }: 
let
  tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tokyo-night";
    version = "unstable-2023-01-03";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "26617ca796c150e2db381b165a63e6d08694be94";
      # nix-prefetch-url --type sha256 --unpack https://github.com/janoamaral/tokyo-night-tmux/archive/refs/heads/master.zip
      sha256 = "1qjg54x4wdr6fbqr3ralqchq83cr2xs498wfk1f2b53fxmv5idj2";
    };
  };

in {
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    # tmuxp.enable = true;
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set-option -sa terminal-overrides ',alacritty:Tc'
      set -g pane-base-index 1
      # session switching
      bind s display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
    '';
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      pain-control
      tokyo-night
    ];
  };


  home.packages = with pkgs; [
    tmuxp
    fzf
  ];

  xdg.configFile = {
    "tmuxp/dot.yaml".source = ./tmuxp/dot.yaml;
    "tmuxp/pro.yaml".source = ./tmuxp/pro.yaml;
  };
}
