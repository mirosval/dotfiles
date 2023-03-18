{ pkgs, ... }: 
{
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
