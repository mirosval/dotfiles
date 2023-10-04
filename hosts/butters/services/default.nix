{ config, pkgs, ... }: {
  imports = [
    #./blocky
    ./homer
    ./lan_dns
    ./traefik
  ];
}
