{ ... }: {
  homeModules.base = _: {
    programs.home-manager.enable = true;
    programs.wezterm.enable = true;
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "github.com" = {
          IdentityFile = "/Users/mirosval/.ssh/id_ed25519";
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
          IgnoreUnknown = "UseKeychain";
        };
        builder = {
          HostName = "127.0.0.1";
          User = "root";
          Port = 3022;
          IdentityFile = "/Users/mirosval/.dotfiles/builders/linux-aarch64/keys/id_ed25519";
          StrictHostKeyChecking = "accept-new";
          PreferredAuthentications = "publickey";
          ServerAliveInterval = 60;
        };
        butters = {
          HostName = "butters";
          User = "miro";
          IdentityFile = "~/.ssh/butters_id_ed25519";
          StrictHostKeyChecking = "accept-new";
          PreferredAuthentications = "publickey";
        };
      };
    };
  };
}
