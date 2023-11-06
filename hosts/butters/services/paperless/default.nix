{ pkgs, config, lib, ... }:
let
  name = "paperless";
  version = "1.17.4";
  dbPath = "/var/containers/paperless/db";
  dbBackupPath = "/var/containers/paperless/db_dumps";
  redisPath = "/var/containers/paperless/redis";
  dataPath = "/mnt/paperless/data";
  mediaPath = "/mnt/paperless/media";
  consumePath = "/mnt/paperless/consume";
  port = "8084";
  domain = "paperless.doma.lol";
in
{
  fileSystems = {
    "/mnt/paperless" = {
      device = "//cartman/paperless";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
          credentials = config.secrets.butters.smb_paperless_rw;
        in
        [ "${automount_opts},credentials=${credentials}" ];
    };
  };

  # Create directories
  system.activationScripts = {
    makeMealieContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${dbPath}
      mkdir -p ${dbBackupPath}
      mkdir -p ${dataPath}
      mkdir -p ${mediaPath}
      mkdir -p ${redisPath}
      mkdir -p ${consumePath}
    '';
  };

  # Create docker network
  systemd.services."init-${name}-network" = {
    description = "Create the network bridge for ${name}.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      # Put a true at the end to prevent getting non-zero return code, which will
      # crash the whole service.
      check=$(${pkgs.podman}/bin/podman network ls | grep "${name}-bridge" || true)
      if [ -z "$check" ];
        then ${pkgs.podman}/bin/podman network create ${name}-bridge
        else echo "${name}-bridge already exists in podman"
      fi
    '';
  };

  virtualisation.oci-containers.containers = {
    paperless-webserver = {
      image = "ghcr.io/paperless-ngx/paperless-ngx:${version}";
      ports = [
        "${port}:8000"
      ];
      volumes = [
        "${dataPath}:/usr/src/paperless/data"
        "${mediaPath}:/usr/src/paperless/media"
        "${consumePath}:/usr/src/paperless/consume"
      ];
      environment = {
        PAPERLESS_REDIS = "redis://paperless-redis:6379";
        PAPERLESS_DBHOST = "paperless-postgres";
        PAPERLESS_URL = "https://${domain}";
        USERMAP_UID = "0";
        USERMAP_GID = "0";
      };
      environmentFiles = [
        config.secrets.butters.paperless
      ];
      dependsOn = [
        "paperless-redis"
        "paperless-postgres"
      ];
      extraOptions = [ "--network=${name}-bridge" ];
    };

    paperless-redis = {
      image = "docker.io/library/redis:7";
      volumes = [
        "${redisPath}:/data/"
      ];
      extraOptions = [ "--network=${name}-bridge" ];
    };

    paperless-postgres = {
      image = "docker.io/library/postgres:15";
      environment = {
        POSTGRES_DB = "paperless";
        POSTGRES_USER = "paperless";
      };
      environmentFiles = [
        config.secrets.butters.paperless
      ];
      volumes = [
        "${dbPath}:/var/lib/postgresql/data"
      ];
      extraOptions = [ "--network=${name}-bridge" ];
    };

    paperless-db-dumper = {
      image = "prodrigestivill/postgres-backup-local";
      environment = {
        SCHEDULE = "@daily";
        BACKUP_NUM_KEEP = "3";
        BACKUP_DIR = "/db_dumps";
        POSTGRES_HOST = "paperless-postgres";
        POSTGRES_DB = "paperless";
        POSTGRES_USER = "paperless";
      };
      environmentFiles = [
        config.secrets.butters.paperless
      ];
      extraOptions = [ "--network=${name}-bridge" ];
      volumes = [
        "${dbBackupPath}:/db_dumps"
      ];
      dependsOn = [
        "paperless-postgres"
      ];
    };
  };

  # DNS
  services.local_dns.service_map = {
    ${name} = "butters";
  };

  # Reverse proxy
  services.traefik.dynamicConfigOptions = {
    http.routers.${name} = {
      rule = "Host(`${name}.doma.lol`)";
      service = name;
      tls = { };
    };
    http.services.${name}.loadBalancer.servers = [{
      url = "http://localhost:${port}";
    }];
  };

  # Backups
  services.restic.backups.cartman = {
    paths = [ dbBackupPath ];
  };
}
