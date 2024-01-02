_: {
  services.nix-daemon.enable = true;

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

  nix = {
    distributedBuilds = true;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      build-users-group = "nixbld";
      extra-nix-path = "nixpkgs=flake:nixpkgs";
    };
    buildMachines = [{
      hostName = "builder";
      system = "aarch64-linux";
      maxJobs = 10;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }];
  };

  programs = {
    zsh.enable = true;
    ssh = {
      knownHosts = {
        builder = {
          hostNames = [ "127.0.0.1" ];
          # cat builders/linux-aarch64/keys/ssh_host_ed25519_key.pub
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcRtYrOd+h2XWhaQcqHEphQ7clzQ10J2C0BdprBFxxG";
        };
      };
    };
  };

  security = {
    pam.enableSudoTouchIdAuth = true;
  };

  services = {
    karabiner-elements.enable = true;
  };

  environment.etc."ssh/ssh_config".text = ''
    Host *
      SendEnv LANG LC_*

    Host builder
      HostName 127.0.0.1
      Port 3022
      User root
      IdentityFile /Users/mirosval/.dotfiles/builders/linux-aarch64/keys/id_ed25519
  '';
}
