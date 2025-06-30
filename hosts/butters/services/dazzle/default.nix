{ lib, pkgs, ... }:
let
  name = "dazzle";
  port = "5007";
  domain = "${name}.doma.lol";
in
{
  system.activationScripts = {
    makeDazzleContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p /tmp/podman-deploy
    '';
  };

  systemd.services.dazzle-watcher = {
    description = "Watcher for the weather service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${./watcher.sh} ${name} ${port}";
      Restart = "always";
    };
    path = with pkgs; [
      bash
      jq
      podman
    ];
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
    http.services.${name}.loadBalancer.servers = [
      {
        url = "http://localhost:${port}";
      }
    ];
  };
}
