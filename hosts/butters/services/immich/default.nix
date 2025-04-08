{ pkgs, config, lib, ... }:
let
  name = "immich";
  immichVersion = "v1.131.3";
  dbPath = "/var/containers/immich/db";
  dbBackupPath = "/var/containers/immich/backups";
  uploadPath = "/mnt/immich";
  externalLibraryRodina = "/mnt/photos_ro/rodina";
  modelCachePath = "/var/containers/immich/model_cache";
  port = "8083";
in
{
  # Create DNS
  services.local_dns.service_map = {
    ${name} = "butters";
  };

  # Create directories
  system.activationScripts = {
    makeImmichContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${modelCachePath}
      mkdir -p ${dbBackupPath}
    '';
  };

  # Create docker network
  systemd.services.init-immich-network = {
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
    immich-server = {
      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
      ports = [
        "${port}:2283"
      ];
      volumes = [
        "${uploadPath}:/usr/src/app/upload"
        "${externalLibraryRodina}:/mnt/media/rodina:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        UPLOAD_LOCATION = "/usr/src/app/upload";
        REDIS_HOSTNAME = "immich-redis";
      };
      environmentFiles = [
        config.secrets.butters.immich_env
      ];
      extraOptions = [ "--network=immich-bridge" ];
      dependsOn = [
        "immich-redis"
        "immich-postgres"
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

    immich-redis = {
      image = "redis:6.2-alpine@sha256:70a7a5b641117670beae0d80658430853896b5ef269ccf00d1827427e3263fa3";
      extraOptions = [ "--network=immich-bridge" ];
    };

    immich-postgres = {
      image = "tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
      environment = { };
      environmentFiles = [
        config.secrets.butters.immich_env
      ];
      volumes = [
        "${dbPath}:/var/lib/postgresql/data"
      ];
      extraOptions = [ "--network=immich-bridge" ];
    };

    immich-db-dumper = {
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
