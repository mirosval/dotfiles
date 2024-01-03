_: {
  services.nix-daemon.enable = true;

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

  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;

      # 120, 90, 60, 30, 12, 6, 2
      KeyRepeat = 2;

      # 120, 94, 68, 35, 25, 15
      InitialKeyRepeat = 15;
    };

    dock = {
      autohide = true;
      show-recents = false;
      launchanim = false;
      tilesize = 43;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      FXEnableExtensionChangeWarning = false;
    };

    trackpad = {
      ActuationStrength = 0;
      FirstClickThreshold = 0;
      SecondClickThreshold = 0;
    };

    CustomUserPreferences = {
      "com.apple.AppleMultitouchTrackpad" = {
        TrackpadThreeFingerHorizSwipeGesture = 1;
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
      };

      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
        TrackpadThreeFingerHorizSwipeGesture = 1;
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
      };
    };
  };
}
