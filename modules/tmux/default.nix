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
    '';
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      pain-control
    ];
  };


  home.packages = with pkgs; [
    tmuxp
  ];

  xdg.configFile = {
    "tmuxp/dot.yaml".source = ./tmuxp/dot.yaml;
    "tmuxp/pro.yaml".source = ./tmuxp/pro.yaml;
  };
}
