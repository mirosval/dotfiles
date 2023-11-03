{ config, lib, ... }:
let
  name = "grist";
  version = "1.1.6";
  dataPath = "/var/containers/${name}/cache";
  port = "8484";
  domain = "${name}.doma.lol";
in
{
  # Create directories
  system.activationScripts = {
    makeMealieContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${dataPath}
    '';
  };

  virtualisation.oci-containers.containers = {
    ${name} = {
      image = "gristlabs/grist:${version}";
      volumes = [
        "${dataPath}:/persist"
      ];
      ports = [
        "${port}:8484"
      ];
      environment = {
        APP_HOME_URL = "https://${domain}";
      };
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
    paths = [ dataPath ];
  };
}
