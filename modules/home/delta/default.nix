{ ... }: {
  homeModules.delta = { pkgs-unstable, ... }: {
    programs.delta = {
      enable = true;
      package = pkgs-unstable.delta;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
      enableJujutsuIntegration = true;
      enableGitIntegration = true;
    };
  };
}
