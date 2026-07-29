{ ... }: {
  homeModules.starship = _: {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
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
      };
    };
  };
}
