{ pkgs, lib, ... }:
let
  port = "8082";
in
{
  system.activationScripts = {
    makeLinkdingContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p /var/containers/linkding
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
        "/var/containers/linkding:/etc/linkding/data"
      ];
      extraOptions = [
        "--name=linkding"
        "--hostname=linkding"
        "--env-file=/etc/containers/linkding/env"
      ];
    };
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.linkding = {
      rule = "Host(`linkding`) || Host(`linkding.lan.zoricak.net`)";
      service = "linkding";
    };
    http.services.linkding.loadBalancer.servers = [{
      url = "http://localhost:${port}";
    }];
  };
}
