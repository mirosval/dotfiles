{ lib, ... }:
let
  port = "8082";
  dataVolume = "/var/containers/linkding";
in
{
  system.activationScripts = {
    makeLinkdingContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${dataVolume}
    '';
  };

  environment.etc."containers/linkding/env".source = ./env;

  virtualisation.oci-containers.containers = {
    linkding = {
      autoStart = true;
      image = "sissbruecker/linkding:latest";
      ports = [
        "${port}:9090"
      ];
      volumes = [
        "${dataVolume}:/etc/linkding/data"
      ];
      extraOptions = [
        "--name=linkding"
        "--hostname=linkding"
        "--env-file=/etc/containers/linkding/env"
      ];
    };
  };

  # Reverse proxy
  services.traefik.dynamicConfigOptions = {
    http.routers.linkding = {
      rule = "Host(`linkding`) || Host(`linkding.lan.zoricak.net`)";
      service = "linkding";
    };
    http.services.linkding.loadBalancer.servers = [{
      url = "http://localhost:${port}";
    }];
  };

  # Backups
  services.restic.backups.cartman = {
    paths = [ dataVolume ];
  };
}
