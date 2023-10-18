{ config, pkgs, ... }: {
  imports = [
    ./blocky
    ./grafana
    ./homer
    ./lan_dns
    ./linkding
    ./loki
    ./prometheus
    ./promtail
    ./traefik
  ];
}
