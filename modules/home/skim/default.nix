{ ... }: {
  homeModules.skim = { pkgs-unstable, ... }: {
    programs.skim = {
      enable = true;
      enableZshIntegration = true;
      package = pkgs-unstable.skim;
    };
  };
}
