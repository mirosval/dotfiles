{ config, pkgs, ... }: {
  imports = [
    #./blocky
    ./blocky
    ./homer
    ./lan_dns
    ./traefik
  ];
}
