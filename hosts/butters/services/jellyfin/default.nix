{ config, lib, ... }:
let
  name = "jellyfin";
  version = "10.8.11";
  cachePath = "/var/containers/${name}/cache";
  configPath = "/var/containers/${name}/config";
  port = "8096";
  domain = "${name}.doma.lol";
in
{
  # Create directories
  system.activationScripts = {
    makeMealieContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${cachePath}
      mkdir -p ${configPath}
    '';
  };

  # mount movies
  fileSystems = {
    "/mnt/movies_ro" = {
      device = "//cartman/movies";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
          credentials = config.secrets.butters.smb_movies_ro;
        in
        [ "${automount_opts},credentials=${credentials}" ];
    };
  };

  virtualisation.oci-containers.containers = {
    ${name} = {
      image = "jellyfin/jellyfin:${version}";
      volumes = [
        "${cachePath}:/cache"
        "${configPath}:/config"
        "/mnt/movies_ro:/media:ro"
      ];
      extraOptions = [ "--network=host" ];
    };
  };

  networking.firewall.allowedUDPPorts = [
    1900
    7395
  ];

  # Reverse proxy
  services.traefik.dynamicConfigOptions = {
    http.routers.${name} = {
      rule = "Host(`${domain}`)";
      service = name;
      tls = { };
    };
    http.services.${name}.loadBalancer.servers = [{
      url = "http://localhost:${port}";
    }];
  };

  # Backups
  services.restic.backups.cartman = {
    paths = [ configPath ];
  };
}
