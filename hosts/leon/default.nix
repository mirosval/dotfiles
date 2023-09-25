{ config, pkgs, ... }: {

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  imports = [
    "${fetchTarball {
      url = "https://github.com/NixOS/nixos-hardware/archive/61283b30d11f27d5b76439d43f20d0c0c8ff5296.tar.gz";
      sha256 = "0lillvagps6qrl8i4y9axwlaal8fh5ch40v9mm0azm1qz76vxkxf";
    }}/raspberry-pi/4"
  ];

  networking = {
    hostName = "leon";
    interfaces.eth0 = {
      useDHCP = true;
    };
    networkmanager.enable = true;
  };
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  # Enable GPU acceleration
  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
      #audio.enable = true;
    };
    deviceTree = {
      enable = true;
      filter = "bcm2711-rpi-4*.dtb";
    };
    pulseaudio.enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  sound.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    firefox
    neovim
    libraspberrypi
    raspberrypi-eeprom
  ];

  programs.zsh.enable = true;


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall = {
    enable = true;
    trustedInterfaces = ["eth0"];
    allowedUDPPorts = [];
    allowedTCPPorts = [22];
  };

  system.stateVersion = "23.05"; # Did you read the comment?

  users = {
    users = {
      leon = {
        home = "/home/leon";
        name = "leon";
        group = "leon";
        isNormalUser = true;
        hashedPassword = "$6$GdYxRxqhfPr1lBDy$5JaCGaE4whQE3npU4ZUpb.XUwHMQ0QzmtnxAEV4dsaHX3fIvEO/OR0C5J2nB106Lcv.vHPzfjR7HUfLDR4T.N.";
      };
      miro = {
        home = "/home/miro";
        name = "miro";
        group = "miro";
        extraGroups = ["networkmanager" "wheel"];
        isNormalUser = true;
        hashedPassword = "$6$3RLqWYW8IQCHGusk$B.gU3zxK0nsvzWSqb7jzXTmTTerQDndRZBJKHOpZ6j0aKdwVzQZiIPFiHp./C9ovZlV3OFo3wLQtKv48kLFtO/";
        openssh = {
          authorizedKeys.keys = [
            "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBACNkFUp0ryOIOaQXrvvyXXYeNQMGOE6qmi5zq21hnM7k6rj1Yd1pJfD0EhT3YP8cXVRSmcaDDq/sT8a2vZAXzgt/wF/kNhLRvFDYwMi8b6z4ryol9tdfs1gmOFThgJTzHYpeOpOTk4BB8I9NmQgyy23qRcyS0uVYIy4PNp9bHnmKORrHA== miroslav.zoricak@gmail.com"
          ];
        };
      };
    };
  };

  # Enable passwordless sudo.
  security.sudo.extraRules= [
    {  users = [ "miro" ];
      commands = [
         { command = "ALL" ;
           options= [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
