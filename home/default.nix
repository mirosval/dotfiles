{ pkgs, ... }: {
  home.stateVersion = "23.05";
  imports = [
    ./alacritty
    ./cli.nix
    ./direnv
    ./fd
    ./fzf
    ./git
    ./hammerspoon
    ./karabiner
    ./navi
    ./nvim
    ./rg
    ./starship
    ./tmux
    ./zoxide
    ./zsh
  ];
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays =
      if pkgs.stdenv.isDarwin then [
        (import ../overlays/libtmux.nix { })
      ] else [ ];
  };

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    home-manager.enable = true;

    ssh = {
      enable = true;
      serverAliveInterval = 60;
      matchBlocks = {
        "github.com" = {
          identityFile = "/Users/mirosval/.ssh/id_ed25519";
          extraOptions = {
            "AddKeysToAgent" = "yes";
            "UseKeychain" = "yes";
            "IgnoreUnknown" = "UseKeychain";
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
        butters = {
          hostname = "butters";
          user = "miro";
          identityFile = "~/.ssh/butters_id_ed25519";
          extraOptions = {
            "StrictHostKeyChecking" = "accept-new";
            "PreferredAuthentications" = "publickey";
          };
        };
      };
    };
  };
}
