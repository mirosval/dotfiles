{ inputs, ... }: {
  flake.nixosConfigurations.jimmy = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      "${inputs.nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      ({ ... }: {
        boot.zfs.forceImportRoot = false;
        system.stateVersion = "24.05";
        networking.interfaces.eth0.useDHCP = true;
        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
          };
        };
        users = {
          users.miro = {
            home = "/home/miro";
            name = "miro";
            group = "miro";
            isNormalUser = true;
            openssh.authorizedKeys.keys = [
              "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBACNkFUp0ryOIOaQXrvvyXXYeNQMGOE6qmi5zq21hnM7k6rj1Yd1pJfD0EhT3YP8cXVRSmcaDDq/sT8a2vZAXzgt/wF/kNhLRvFDYwMi8b6z4ryol9tdfs1gmOFThgJTzHYpeOpOTk4BB8I9NmQgyy23qRcyS0uVYIy4PNp9bHnmKORrHA== miroslav.zoricak@gmail.com"
            ];
          };
          groups.miro = {};
        };
      })
    ];
    specialArgs = { inherit inputs; };
  };
}
