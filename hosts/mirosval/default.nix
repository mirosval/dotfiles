_: {
  imports = [
    ../../modules/darwin
  ];

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
      "handbrake"
      "iina"
      "logseq"
      "quicklook-csv"
      "quicklook-json"
      "raycast"
      "spotify"
      "steam"
      "tableplus"
      "tailscale"
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
}
