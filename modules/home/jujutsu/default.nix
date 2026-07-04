{ ... }: {
  homeModules.jujutsu = { pkgs-unstable, ... }: {
    programs.jujutsu = {
      enable = true;
      package = pkgs-unstable.jujutsu;
      settings = {
        ui = { editor = "nvim"; default-command = "log"; };
        git.sign-on-push = true;
        user = {
          name = "Miroslav Zoricak";
          email = "1315417+mirosval@users.noreply.github.com";
        };
      };
    };
  };
}
