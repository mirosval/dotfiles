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
      };
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          to-homer = {
            rule = "Host(`dash`) || Host(`dash.lan`) || Host(`dash.butters.lan`)";
            service = "homer";
          };
        };
        services = {
          homer = {
            loadBalancer = {
              servers = [
                "localhost:8081"
              ];
            };
          };
        };
      };
    };
  };
}
