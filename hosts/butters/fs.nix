{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems = {
    "/mnt/photos_ro" = {
      device = "//cartman/photos";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
          credentials = config.secrets.butters.smb_photos_ro;
        in
        [ "${automount_opts},credentials=${credentials}" ];
    };
    "/mnt/immich" = {
      device = "//cartman/photos/immich";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
          credentials = config.secrets.butters.smb_immich_rw;
        in
        [ "${automount_opts},credentials=${credentials}" ];
    };
  };
}
