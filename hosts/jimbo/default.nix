_: {
  imports = [
    ../../modules/darwin
  ];

  homebrew = {
    enable = true;
    brews = [ ];
    casks = [
      "docker"
      "firefox"
      "flux"
      "fork"
      "google-chrome"
      "hammerspoon"
      "jetbrains-toolbox"
      "quicklook-csv"
      "quicklook-json"
      "raycast"
      "spotify"
      "the-unarchiver"
      "visual-studio-code"
    ];
  };

  networking = {
    computerName = "Miroslavs Work MBP";
    hostName = "miroslavs-work-mbp";
    localHostName = "miroslavs-work-mbp";
  };

  ids.gids.nixbld = 30000;
}
