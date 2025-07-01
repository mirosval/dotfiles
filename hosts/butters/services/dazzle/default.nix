{ pkgs, ... }:
let
  name = "dazzle";
  port = "5007";
  containerPort = "3000";
  ports = "${port}:${containerPort}";
  domain = "${name}.doma.lol";
  image = "gitea.doma.lol/miro/${name}:latest";
in
{
  systemd.timers.dazzle-watcher = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
      Unit = "dazzle-watcher.service";
    };
  };

  systemd.services.dazzle-watcher = {
    description = "Watcher for the weather service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${./watcher.sh} ${image} ${name} ${ports}";
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = with pkgs; [
      bash
      jq
      podman
      skopeo
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
