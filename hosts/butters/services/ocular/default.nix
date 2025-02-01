{ pkgs, config, lib, ... }:
let
  name = "ocular";
  ocularVersion = "v1.8.1";
  genesisVersion = "v1.4.0";
  dataVolume = "/var/containers/ocular/data";
  port = "8085";
in
{
  # Create DNS
  services.local_dns.service_map = {
    ${name} = "butters";
  };

  system.activationScripts = {
    makeOcularContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${dataVolume}
    '';
  };

  # Create docker network
  systemd.services.init-ocular-network = {
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
    genesis = {
      image = "ghcr.io/simonwep/genesis:${genesisVersion}";
      volumes = [
        "${dataVolume}:/app/.data"
      ];
      environment = {
        # Database location
        GENESIS_DB_PATH = ".data";

        # JWT secret known only to your token generator
        # Provided ia secret
        # GENESIS_JWT_SECRET="";

        # JWT expiration in minutes
        GENESIS_JWT_TOKEN_EXPIRATION = "120960";

        # If the session cookie for the backend should be allowed to be sent over http
        # Dangerous, it's best to run it behind a reverse proxy with https
        GENESIS_JWT_COOKIE_ALLOW_HTTP="false";

        # Gin mode, either test, release or debug
        GENESIS_GIN_MODE="release";

        # Zap loggger, either production or development
        GENESIS_LOG_MODE="production";

        # Port to listen on, leave it at 80 if you're using a reverse proxy
        GENESIS_PORT="80";

        # Base url to listen for requests
        GENESIS_BASE_URL="/";

        # Use ! as suffix for the username to indicate that this user
        # should be created as an admin. These can add, remove and edit users.
        # Provided ia secret
        # GENESIS_CREATE_USERS="admin!:2lWK6m4hgmxjUGHo";

        # Allowed username pattern
        GENESIS_USERNAME_PATTERN="^[\w]{0,32}$";

        # Allowed key pattern
        GENESIS_KEY_PATTERN="^[\w]{0,32}$";

        # Maximum size of each key in kilobytes
        GENESIS_DATA_MAX_SIZE="512";

        # Maximum amount of datasets per user
        GENESIS_KEYS_PER_USER="2";
      };
      environmentFiles = [
        config.secrets.butters.ocular_env
      ];
      extraOptions = [ "--network=${name}-bridge" ];
    };

    ocular = {
      image = "ghcr.io/simonwep/ocular:${ocularVersion}";
      ports = [
        "${port}:80"
      ];
      extraOptions = [ "--network=${name}-bridge" ];
      dependsOn = [
        "genesis"
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
    paths = [ dataVolume ];
  };
}
