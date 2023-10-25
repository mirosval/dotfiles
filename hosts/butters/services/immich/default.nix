{ pkgs, config, lib, ... }:
let
  immichVersion = "v1.82.1";
  dbBackupPath = "/var/containers/immich/backups";
  uploadPath = "/mnt/immich";
  externalLibraryRodina = "/mnt/photos_ro/rodina";
  modelCachePath = "/var/containers/immich/model_cache";
  typesensePath = "/var/containers/immich/typesense";
  port = "8083";
in
{
  # Create directories
  system.activationScripts = {
    makeImmichContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${modelCachePath}
      mkdir -p ${typesensePath}
      mkdir -p ${dbBackupPath}
    '';
  };

  # Create docker network
  systemd.services.init-immich-network = {
    description = "Create the network bridge for immich.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      # Put a true at the end to prevent getting non-zero return code, which will
      # crash the whole service.
      check=$(${pkgs.podman}/bin/podman network ls | grep "immich-bridge" || true)
      if [ -z "$check" ];
        then ${pkgs.podman}/bin/podman network create immich-bridge
        else echo "immich-bridge already exists in podman"
      fi
    '';
  };

  virtualisation.oci-containers.containers = {
    immich-server = {
      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
      cmd = [ "start.sh" "immich" ];
      volumes = [
        "${uploadPath}:/usr/src/app/upload"
        "${externalLibraryRodina}:/mnt/media/rodina:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        UPLOAD_LOCATION = "/usr/src/app/upload";
        TYPESENSE_HOST = "immich-typesense";
        REDIS_HOSTNAME = "immich-redis";
      };
      environmentFiles = [
        config.secrets.butters.immich_env
      ];
      extraOptions = [ "--network=immich-bridge" ];
      dependsOn = [
        "immich-redis"
        "immich-postgres"
        "immich-typesense"
      ];
    };

    immich-microservices = {
      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
      cmd = [ "start.sh" "microservices" ];
      volumes = [
        "${uploadPath}:/usr/src/app/upload"
        "${externalLibraryRodina}:/mnt/media/rodina:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        REDIS_HOSTNAME = "immich-redis";
        TYPESENSE_HOST = "immich-typesense";
      };
      environmentFiles = [
        config.secrets.butters.immich_env
      ];
      extraOptions = [ "--network=immich-bridge" ];
      dependsOn = [
        "immich-redis"
        "immich-postgres"
        "immich-typesense"
      ];
    };

    immich-machine-learning = {
      image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}";
      volumes = [
        "${modelCachePath}:/cache"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = { };
      environmentFiles = [
        config.secrets.butters.immich_env
      ];
      extraOptions = [ "--network=immich-bridge" ];
    };

    immich-web = {
      image = "ghcr.io/immich-app/immich-web:${immichVersion}";
      environmentFiles = [
        config.secrets.butters.immich_env
      ];
      extraOptions = [ "--network=immich-bridge" ];
    };

    immich-typesense = {
      image = "typesense/typesense:0.24.1@sha256:9bcff2b829f12074426ca044b56160ca9d777a0c488303469143dd9f8259d4dd";
      volumes = [
        "${typesensePath}:/data"
      ];
      environment = {
        TYPESENSE_DATA_DIR = "/data";
        # remove this to get debug messages
        GLOG_minloglevel = "1";
      };
      environmentFiles = [
        config.secrets.butters.immich_env
      ];
      extraOptions = [ "--network=immich-bridge" ];
    };

    immich-redis = {
      image = "redis:6.2-alpine@sha256:70a7a5b641117670beae0d80658430853896b5ef269ccf00d1827427e3263fa3";
      extraOptions = [ "--network=immich-bridge" ];
    };

    immich-postgres = {
      image = "postgres:14-alpine@sha256:28407a9961e76f2d285dc6991e8e48893503cc3836a4755bbc2d40bcc272a441";
      environment = { };
      environmentFiles = [
        config.secrets.butters.immich_env
      ];
      extraOptions = [ "--network=immich-bridge" ];
    };

    immich-proxy = {
      image = "ghcr.io/immich-app/immich-proxy:${immichVersion}";
      environment = {
        IMMICH_SERVER_URL = "http://immich-server:3001";
        IMMICH_WEB_URL = "http://immich-web:3000";
      };
      extraOptions = [ "--network=immich-bridge" ];
      ports = [
        "${port}:8080"
      ];
      dependsOn = [
        "immich-server"
        "immich-web"
      ];
    };

    immich_db_dumper = {
      image = "prodrigestivill/postgres-backup-local";
      environment = {
        SCHEDULE = "@hourly";
        BACKUP_NUM_KEEP = "3";
        BACKUP_DIR = "/db_dumps";
      };
      environmentFiles = [
        config.secrets.butters.immich_env
      ];
      extraOptions = [ "--network=immich-bridge" ];
      volumes = [
        "${dbBackupPath}:/db_dumps"
      ];
      dependsOn = [
        "immich-postgres"
      ];
    };

  };

  # Reverse proxy
  services.traefik.dynamicConfigOptions = {
    http.routers.immich = {
      rule = "Host(`immich`) || Host(`immich.lan.zoricak.net`)";
      service = "immich";
    };
    http.services.immich.loadBalancer.servers = [{
      url = "http://localhost:${port}";
    }];
  };

  # Backups
  services.restic.backups.cartman = {
    paths = [ dbBackupPath ];
  };
}
