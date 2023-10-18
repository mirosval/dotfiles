{ pkgs, ... }: {
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      api = {
        insecure = true;
        dashboard = true;
      };
      entryPoints = {
        http = {
          address = ":80";
        };
        https = {
          address = ":443";
        };
      };
      log = {
        level = "INFO";
        format = "json";
      };
      accessLog = {
        format = "json";
        fields = {
          defaultMode = "keep";
          headers = {
            defaultMode = "keep";
          };
        };
      };
    };

    dynamicConfigOptions = {
      http.routers.to-homer = {
        rule = "Host(`dash`) || Host(`dash.home.arpa`)";
        service = "homer";
      };
      http.routers.to-linkding = {
        rule = "Host(`linkding`) || Host(`linkding.home.arpa`)";
        service = "linkding";
      };
      http.services.homer.loadBalancer.servers = [{
        url = "http://localhost:8081";
      }];
      http.services.linkding.loadBalancer.servers = [{
        url = "http://localhost:8082";
      }];
    };
  };
}
