{ pkgs, config, lib, ... }:
let
  name = "baserow";
  version = "1.21.2";
  dataPath = "/var/containers/${name}/data";
  dbPath = "/var/containers/${name}/db";
  dbBackupPath = "/var/containers/${name}/db_backup";
  port = "8084";
  domain = "${name}.doma.lol";
  network = "${name}-bridge";
in
{
  # Create directories
  system.activationScripts = {
    makeMealieContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${dataPath}
      mkdir -p ${dbPath}
      mkdir -p ${dbBackupPath}
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
      check=$(${pkgs.podman}/bin/podman network ls | grep "${network}" || true)
      if [ -z "$check" ];
        then ${pkgs.podman}/bin/podman network create ${network}
        else echo "${network} already exists in podman"
      fi
    '';
  };

  virtualisation.oci-containers.containers = {
    ${name} = {
      image = "baserow/baserow:${version}";
      volumes = [
        "${dataPath}:/baserow/data"
      ];
      ports = [
        "${port}:80"
      ];
      extraOptions = [ "--network=${network}" ];
      environment = {
        BASEROW_PUBLIC_URL = "https://${domain}";
      };
      environmentFiles = [
        config.secrets.butters.baserow_env
      ];
      dependsOn = [
        "${name}-db"
      ];
    };

    "${name}-db" = {
      image = "postgres:16-alpine";
      environment = { };
      environmentFiles = [
        config.secrets.butters.baserow_env
      ];
      volumes = [
        "${dbPath}:/var/lib/postgresql/data"
      ];
      extraOptions = [ "--network=${network}" ];
    };

    "${name}-db-dumper" = {
      image = "prodrigestivill/postgres-backup-local";
      environment = {
        SCHEDULE = "@hourly";
        BACKUP_NUM_KEEP = "3";
        BACKUP_DIR = "/db_dumps";
        POSTGRES_DB = "${name}-db";
      };
      environmentFiles = [
        config.secrets.butters.baserow_env
      ];
      extraOptions = [ "--network=${network}" ];
      volumes = [
        "${dbBackupPath}:/db_dumps"
      ];
      dependsOn = [
        "${name}-db"
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
    paths = [
      dataPath
      dbBackupPath
    ];
  };
}
