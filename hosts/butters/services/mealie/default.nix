{ pkgs, config, lib, ... }:
let
  mealieVersion = "v1.0.0-RC1.1";
  dbPath = "/var/containers/mealie/db";
  dbBackupPath = "/var/containers/mealie/db_dumps";
  dataPath = "/var/containers/mealie/data";
  port = "9925";
  domain = "mealie.doma.lol";
in
{
  # Create directories
  system.activationScripts = {
    makeMealieContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${dbPath}
      mkdir -p ${dbBackupPath}
      mkdir -p ${dataPath}
    '';
  };

  # Create docker network
  systemd.services.init-mealie-network = {
    description = "Create the network bridge for mealie.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      # Put a true at the end to prevent getting non-zero return code, which will
      # crash the whole service.
      check=$(${pkgs.podman}/bin/podman network ls | grep "mealie-bridge" || true)
      if [ -z "$check" ];
        then ${pkgs.podman}/bin/podman network create mealie-bridge
        else echo "mealie-bridge already exists in podman"
      fi
    '';
  };

  virtualisation.oci-containers.containers = {
    mealie = {
      image = "ghcr.io/mealie-recipes/mealie:${mealieVersion}";
      ports = [
        "${port}:9000"
      ];
      dependsOn = [ "mealie-postgres" ];
      volumes = [
        "${dataPath}:/app/data/"
      ];
      environment = {
        ALLOW_SIGNUP = "true";
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Berlin";
        MAX_WORKERS = "1";
        WEB_CONCURRENCY = "1";
        DB_ENGINE = "postgres";
        BASE_URL = "https://${domain}";
      };
      environmentFiles = [
        config.secrets.butters.mealie
      ];
      extraOptions = [ "--network=mealie-bridge" ];
    };

    mealie-postgres = {
      image = "postgres:15";
      environmentFiles = [
        config.secrets.butters.mealie
      ];
      volumes = [
        "${dbPath}:/var/lib/postgresql/data"
      ];
      extraOptions = [ "--network=mealie-bridge" ];
    };

    mealie-db-dumper = {
      image = "prodrigestivill/postgres-backup-local";
      environment = {
        SCHEDULE = "@daily";
        BACKUP_NUM_KEEP = "3";
        BACKUP_DIR = "/db_dumps";
        POSTGRES_HOST = "mealie-postgres";
      };
      environmentFiles = [
        config.secrets.butters.mealie
      ];
      extraOptions = [ "--network=mealie-bridge" ];
      volumes = [
        "${dbBackupPath}:/db_dumps"
      ];
      dependsOn = [
        "mealie-postgres"
      ];
    };
  };

  # Reverse proxy
  services.traefik.dynamicConfigOptions = {
    http.routers.mealie = {
      rule = "Host(`mealie.doma.lol`)";
      service = "mealie";
      tls = { };
    };
    http.services.mealie.loadBalancer.servers = [{
      url = "http://localhost:${port}";
    }];
  };

  # Backups
  services.restic.backups.cartman = {
    paths = [ dbBackupPath ];
  };
}
