{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    # tmuxp.enable = true;
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set-option -sa terminal-features ',alacritty:RGB'
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"
      set -g pane-base-index 1

      # Fix copy-paste
      # Don't copy on mouse release
      unbind -T copy-mode-vi             MouseDragEnd1Pane
      # Selection keybind
      bind   -T copy-mode-vi v   send -X begin-selection
      # Toggle selection mode
      bind   -T copy-mode-vi C-v send -X rectangle-toggle
      # Copy to clipboard
      bind   -T copy-mode-vi y   send -X copy-pipe "reattach-to-user-namespace pbcopy" \; send -X clear-selection 
      bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe "reattach-to-user-namespace pbcopy" \; send -X clear-selection

      # session switching
      bind s display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"

      set -g @tmux_power_theme '#483D8B'
      # TokyoNight colors for Tmux

      set -g mode-style "fg=#7aa2f7,bg=#3b4261"

      set -g message-style "fg=#7aa2f7,bg=#3b4261"
      set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

      set -g pane-border-style "fg=#3b4261"
      set -g pane-active-border-style "fg=#7aa2f7"

      set -g status "on"
      set -g status-justify "left"

      set -g status-style "fg=#7aa2f7,bg=#1f2335"

      set -g status-left-length "100"
      set -g status-right-length "100"

      set -g status-left-style NONE
      set -g status-right-style NONE

      set -g status-left "#[fg=#1d202f,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#1f2335,nobold,nounderscore,noitalics]"
      set -g status-right "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#1f2335] #{prefix_highlight} #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %H:%M:%S #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#1d202f,bg=#7aa2f7,bold] #h "

      setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#1f2335"
      setw -g window-status-separator ""
      setw -g window-status-style "NONE,fg=#a9b1d6,bg=#1f2335"
      setw -g window-status-format "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#1f2335,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]"

      # tmux-plugins/tmux-prefix-highlight support
      set -g @prefix_highlight_output_prefix "#[fg=#e0af68]#[bg=#1f2335]#[fg=#1f2335]#[bg=#e0af68]"
      set -g @prefix_highlight_output_suffix ""
    '';
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      pain-control
    ];
  };


  home.packages = with pkgs; [
    unstable.tmuxp
    fzf
  ] ++ (
    if pkgs.stdenv.isDarwin then
      [
        pkgs.reattach-to-user-namespace
        pam-reattach # Touch ID in tmux
      ]
    else
      [ ]
  );

  xdg.configFile = {
    "tmuxp/dot.yaml".source = ./tmuxp/dot.yaml;
    "tmuxp/pro.yaml".source = ./tmuxp/pro.yaml;
  };
}
