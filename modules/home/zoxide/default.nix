{ ... }: {
  homeModules.zoxide = _: {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
