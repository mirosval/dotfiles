{ pkgs, ... }:
let
  configFile = ((pkgs.formats.yaml { }).generate "dashy_config.yml"
    {
      pageInfo.title = "doma.lol";
      appConfig = {
        statusCheck = true;
        theme = "crayola";
        preventWriteToDisk = true;
        disableConfiguration = true;
        hideComponents = {
          hideSettings = true;
          hideFooter = true;
        };
      };
      sections = [
        {
          name = "Apps";
          items = [
            {
              title = "Immich";
              url = "https://immich.doma.lol";
              icon = "hl-immich";
            }
            {
              title = "Linkding";
              url = "https://linkding.doma.lol";
              icon = "hl-linkding";
            }
            {
              title = "Mealie";
              url = "https://mealie.doma.lol";
              icon = "hl-mealie";
            }
          ];
        }
        {
          name = "Network";
          items = [
            {
              title = "UniFi";
              url = "http://192.168.1.1";
              icon = "hl-unifi";
            }
            {
              title = "Traefik";
              url = "http://butters.doma.lol:8080";
              icon = "hl-traefik";
            }
          ];
        }
        {
          name = "Monitoring";
          items = [
            {
              title = "Grafana";
              url = "http://grafana.doma.lol";
              icon = "hl-grafana";
            }
          ];
        }
      ];
    });
in
{
  virtualisation.oci-containers.containers = {
    dashy = {
      autoStart = true;
      image = "ghcr.io/lissy93/dashy:2.1.1";
      ports = [
        "8081:80"
      ];
      volumes = [
        "${configFile}:/app/public/conf.yml:ro"
      ];
    };
  };

  services.traefik.dynamicConfigOptions = {
    http.routers.dashy = {
      rule = "Host(`dash.doma.lol`)";
      service = "dashy";
      tls = { };
    };
    http.services.dashy.loadBalancer.servers = [{
      url = "http://localhost:8081";
    }];
  };
}
