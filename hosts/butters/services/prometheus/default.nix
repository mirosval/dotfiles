{ config, ... }:
{
  services.prometheus = {
    enable = true;
    port = 9001;
    retentionTime = "90d";
    globalConfig.scrape_interval = "15s";
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "butters";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
      {
        job_name = "unbound";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.unbound.port}" ];
          }
        ];
      }
    ];
  };
}
