{ config, ... }: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        router_logging = true;
        http_port = 2342;
        http_addr = "127.0.0.1";
        root_url = "http://grafana.lan.zoricak.net/";
      };
    };
  };

  services.traefik = {
    dynamicConfigOptions = {
      http.routers.grafana = {
        rule = "Host(`grafana`) || Host(`grafana.lan.zoricak.net`)";
        service = "grafana";
      };
      http.services.grafana.loadBalancer.servers =
        let
          addr = config.services.grafana.settings.server.http_addr;
          port = toString config.services.grafana.settings.server.http_port;
        in
        [{
          url = "http://${addr}:${port}";
        }];
    };
  };
}
