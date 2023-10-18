{ pkgs, config, lib, ... }: {
  services.loki = {
    enable = true;
    configFile = ./config.yaml;
  };
  system.activationScripts.makeLokiDir = lib.stringAfter [ "var" ] ''
    mkdir -p /var/lib/loki/boltdb-shipper-active
    mkdir -p /var/lib/loki/boltdb-shipper-cache
    mkdir -p /var/lib/loki/chunks
    mkdir -p /var/lib/loki/compactor
  '';
}
