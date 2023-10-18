{ config, pkgs, ... }: {
  imports = [
    ./blocky
    ./grafana
    ./homer
    ./lan_dns
    ./linkding
    ./traefik
  ];
}
