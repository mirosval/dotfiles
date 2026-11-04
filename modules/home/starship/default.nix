{ ... }: {
  homeModules.starship = { pkgs-unstable, ... }: {
    programs.starship = {
      enable = true;
      package = pkgs-unstable.starship;
      enableZshIntegration = true;
      settings = {
        format = "$username$hostname$kubernetes$directory$vcs$nodejs$python$rust$scala$terraform$nix_shell$aws$direnv$battery$time$status$shell\n$character";
        add_newline = false;
        profiles = {
          claude-code = "$claude_model$claude_context$claude_cost";
        };
        battery = {
          full_symbol = "🔋";
          charging_symbol = "⚡️";
          discharging_symbol = "💀";
        };
        claude_context.display = {
          threshold = "0";
          hidden = "false";
        };
        vcs.order = [
          "jj"
          "git"
        ];
      };
    };
  };
}
