{ pkgs, ... }:
{
  home.stateVersion = "24.05";
  imports = [
    ./alacritty
    ./claude
    ./cli.nix
    ./delta
    ./direnv
    ./fd
    ./git
    ./hammerspoon
    ./jujutsu
    ./karabiner
    ./navi
    ./nvim
    ./rg
    ./skim
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
      if pkgs.stdenv.isDarwin then
        [
          (import ../overlays/libtmux.nix { })
        ]
      else
        [ ];
  };

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    home-manager.enable = true;
    wezterm.enable = true;

    ssh = {
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
