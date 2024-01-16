{ lib, ... }:
let
  name = "actual";
  version = "24.1.0";
  port = "5006";
  dataVolume = "/var/containers/actual";
  domain = "${name}.doma.lol";
in
{
  system.activationScripts = {
    makeLinkdingContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${dataVolume}
    '';
  };

  virtualisation.oci-containers.containers = {
    actual = {
      autoStart = true;
      image = "ghcr.io/actualbudget/actual-server:${version}";
      ports = [
        "${port}:5006"
      ];
      volumes = [
        "${dataVolume}:/data"
      ];
      extraOptions = [
        "--name=actual"
        "--hostname=actual"
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
    paths = [ dataVolume ];
  };
}
