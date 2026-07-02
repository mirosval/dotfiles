{ inputs, ... }: {
  flake.nixosConfigurations.leon = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      ({ pkgs, ... }: {
        nixpkgs.overlays = [
          (_: super: {
            makeModulesClosure = x:
              super.makeModulesClosure (x // { allowMissing = true; });
          })
        ];

        boot.kernelPackages = pkgs.linuxPackages_latest;

        networking = {
          hostName = "leon";
          interfaces.eth0.useDHCP = true;
          networkmanager.enable = true;
          firewall = {
            enable = true;
            trustedInterfaces = [ "eth0" ];
            allowedUDPPorts = [];
            allowedTCPPorts = [ 22 ];
          };
        };

        time.timeZone = "Europe/Berlin";
        i18n.defaultLocale = "en_US.UTF-8";

        hardware = {
          raspberry-pi."4" = {
            apply-overlays-dtmerge.enable = true;
            fkms-3d.enable = true;
          };
          deviceTree = {
            enable = true;
            filter = "bcm2711-rpi-4*.dtb";
          };
        };

        services = {
          openssh = {
            enable = true;
            settings = {
              PermitRootLogin = "no";
              PasswordAuthentication = false;
            };
          };
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;
        };

        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = with pkgs; [
          firefox
          neovim
          libraspberrypi
          raspberrypi-eeprom
        ];

        programs.zsh.enable = true;

        fileSystems."/" = {
          device = "/dev/disk/by-label/NIXOS_SD";
          fsType = "ext4";
          options = [ "noatime" ];
        };

        system.stateVersion = "24.05";

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
              extraGroups = [ "networkmanager" "wheel" ];
              isNormalUser = true;
              hashedPassword = "$6$3RLqWYW8IQCHGusk$B.gU3zxK0nsvzWSqb7jzXTmTTerQDndRZBJKHOpZ6j0aKdwVzQZiIPFiHp./C9ovZlV3OFo3wLQtKv48kLFtO/";
              openssh.authorizedKeys.keys = [
                "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBACNkFUp0ryOIOaQXrvvyXXYeNQMGOE6qmi5zq21hnM7k6rj1Yd1pJfD0EhT3YP8cXVRSmcaDDq/sT8a2vZAXzgt/wF/kNhLRvFDYwMi8b6z4ryol9tdfs1gmOFThgJTzHYpeOpOTk4BB8I9NmQgyy23qRcyS0uVYIy4PNp9bHnmKORrHA== miroslav.zoricak@gmail.com"
              ];
            };
          };
          groups.miro = {};
          groups.leon = {};
        };

        security.sudo.extraRules = [
          {
            users = [ "miro" ];
            commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
          }
        ];
      })
    ];
    specialArgs = { inherit inputs; };
  };
}
