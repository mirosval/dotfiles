{ lib, ... }:
let
  name = "weather";
  port = "5007";
  domain = "${name}.doma.lol";
in
{
  system.activationScripts = {
    makeWeatherContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p /etc/podman-deploy
    '';
  };

  systemd.services.weather-watcher = {
    description = "Watcher for the weather service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${./watcher.sh} ${name} ${port}";
      Restart = "always";
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
    http.services.${name}.loadBalancer.servers = [
      {
        url = "http://localhost:${port}";
      }
    ];
  };
}
