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
              description = "View and manage photos";
              url = "https://immich.doma.lol";
              icon = "hl-immich";
            }
            {
              title = "Linkding";
              description = "Link Aggregator";
              url = "https://linkding.doma.lol";
              icon = "hl-linkding";
            }
            {
              title = "Mealie";
              description = "Meal Planner";
              url = "https://mealie.doma.lol";
              icon = "hl-mealie";
            }
            {
              title = "Jellyfin";
              description = "Watch Movies and TV Shows";
              url = "https://jellyfin.doma.lol";
              icon = "hl-jellyfin";
            }
          ];
        }
        {
          name = "Network";
          items = [
            {
              title = "UniFi";
              description = "Network setup";
              url = "http://192.168.1.1";
              icon = "hl-unifi";
            }
            {
              title = "Traefik";
              description = "Reverse Proxy";
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
              description = "Fancy Graphs";
              url = "http://grafana.doma.lol";
              icon = "hl-grafana";
            }
          ];
        }
      ];
    });
in
{
  # DNS Mapping
  services.local_dns.service_map = {
    dash = "butters";
  };

  # Container
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

  # Reverse Proxy
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
