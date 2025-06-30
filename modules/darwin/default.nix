_: {
  nixpkgs.overlays = [
    (self: super: {
      karabiner-elements = super.karabiner-elements.overrideAttrs (old: {
        version = "14.13.0";
        src = super.fetchurl {
          inherit (old.src) url;
          hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
        };
      });
    })
  ];

  nix = {
    distributedBuilds = true;
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
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
    pam.services.sudo_local.touchIdAuth = true;
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

  system.stateVersion = 5;
  system.primaryUser = "mirosval";
  system.defaults = {
    NSGlobalDomain = {
      # Show file extensions in Finder
      AppleShowAllExtensions = true;

      # Enable keyboard controls in all dialogs
      AppleKeyboardUIMode = 3;

      # Always expand save panel
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      # Disable Spell-check
      NSAutomaticSpellingCorrectionEnabled = false;

      # Disable quote substitution
      NSAutomaticQuoteSubstitutionEnabled = false;

      # Disable period substitution
      NSAutomaticPeriodSubstitutionEnabled = false;

      # Disable dash substitution
      NSAutomaticDashSubstitutionEnabled = false;

      # Disable automatic capitalization
      NSAutomaticCapitalizationEnabled = false;

      # Keyboard key repeat frequency
      # 120, 90, 60, 30, 12, 6, 2
      KeyRepeat = 2;

      # Delay before the keyboard key repeat freq kicks in
      # 120, 94, 68, 35, 25, 15
      InitialKeyRepeat = 15;
    };

    dock = {
      # Hide the dock
      autohide = true;
      # Recent applications section
      show-recents = false;
      # Animations of app launches
      launchanim = false;
      # Icon size
      tilesize = 43;
    };

    finder = {
      # Show file extensions in Finder
      AppleShowAllExtensions = true;
      # Show files as a list
      FXPreferredViewStyle = "Nlsv";
      # Disable warnings when changing file extensions
      FXEnableExtensionChangeWarning = false;
    };

    trackpad = {
      # Light touch trackpad
      ActuationStrength = 0;
      FirstClickThreshold = 0;
      SecondClickThreshold = 0;
    };

    CustomUserPreferences = {
      "com.apple.finder" = {
        # Show folders first in Finder
        "_FXSortFoldersFirst" = true;
      };

      "com.apple.menuextra.clock" = {
        # Status bar time format
        DateFormat = ''"EEE d MMM HH:mm:ss"'';
      };

      "com.apple.AppleMultitouchTrackpad" = {
        # Use tree-finger swipe to go back and forth in (browser) history
        TrackpadThreeFingerHorizSwipeGesture = 1;
        # Disable 2 fingers from the right widgets view
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
      };

      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
        # Use tree-finger swipe to go back and forth in (browser) history
        TrackpadThreeFingerHorizSwipeGesture = 1;
        # Disable 2 fingers from the right widgets view
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
      };
    };
  };
}
