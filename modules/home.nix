{pkgs, ...}: {
  home.username = "mirosval";
  home.homeDirectory = "/Users/mirosval";
  home.stateVersion = "23.05";
  home.enableNixpkgsReleaseCheck = true;

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    home-manager.enable = true;

    ssh = {
      enable = true;
      serverAliveInterval = 60;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github_ed25519";
          extraOptions = {
            "AddKeysToAgent" = "yes";
            "UseKeychain" = "yes";
            "PreferredAuthentications" = "publickey";
          };
        };
        "pihole.local" = {
          hostname = "pihole.local";
          user = "pi";
          identityFile = "~/.ssh/pihole";
          extraOptions = {
            "AddKeysToAgent" = "yes";
            "UseKeychain" = "yes";
            "PreferredAuthentications" = "publickey";
          };
        };
        builder = {
          hostname = "127.0.0.1";
          user = "root";
          port = 3022;
          identityFile = "/Users/mirosval/.dotfiles/builders/linux-aarch64/keys/id_ed25519";
          extraOptions = {
            "StrictHostKeyChecking" = "accept-new";
            "PreferredAuthentications" = "publickey";
          };
        };
      };
    };
  };
}
