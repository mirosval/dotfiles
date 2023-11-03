{ config, ... }:
let
  name = "grafana";
in
{

  services.local_dns.service_map =
    {
      ${name} = "butters";
    };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        router_logging = true;
        http_port = 2342;
        http_addr = "127.0.0.1";
        root_url = "https://${name}.doma.lol/";
      };
    };
  };

  services.traefik = {
    dynamicConfigOptions = {
      http.routers.grafana = {
        rule = "Host(`${name}.doma.lol`)";
        service = name;
        tls = { };
      };
      http.services.${name}.loadBalancer.servers =
        let
          addr = config.services.${name}.settings.server.http_addr;
          port = toString config.services.${name}.settings.server.http_port;
        in
        [{
          url = "http://${addr}:${port}";
        }];
    };
  };
}
