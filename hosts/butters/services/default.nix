{ config, pkgs, ... }: {
  imports = [
    ./blocky
    ./dnsmasq
    ./homer
    ./lan_dns
    ./traefik
  ];
}
