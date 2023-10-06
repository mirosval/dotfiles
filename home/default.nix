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
    overlays = [
      (import ../overlays/libtmux.nix)
    ];
  };
  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    home-manager.enable = true;

    ssh = {
      enable = true;
      serverAliveInterval = 60;
      matchBlocks = {
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
