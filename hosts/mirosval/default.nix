{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  
  homebrew = {
    enable = true;
    brews = [ ];
    casks = [
      "discord"
      "docker"
      "firefox"
      "flux"
      "fork"
      "google-chrome"
      "hammerspoon"
      "iina"
      "logseq"
      "quicklook-csv"
      "quicklook-json"
      "raycast"
      "spotify"
      "steam"
      "tableplus"
      "the-unarchiver"
      "tunnelblick"
      "visual-studio-code"
      "vlc"
    ];
  };

  networking = {
    computerName = "Miro Home MBP";
    hostName = "mirosval";
  };

  programs.zsh.enable = true;

  security = {
    pam.enableSudoTouchIdAuth = true;
  };

  services = {
    karabiner-elements.enable = true;
  };
}
