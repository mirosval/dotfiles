{ lib, config, pkgs, ... }:
let
  name = "gitea";
  port = "8097";
  dataVolume = "/var/containers/gitea";
  domain = "${name}.doma.lol";
in
{
  system.activationScripts = {
    makeGiteaContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${dataVolume}
    '';
  };

  services.gitea = {
    enable = true;
    lfs.enable = true;
    stateDir = dataVolume;

    settings = {
      server = {
        HTTP_PORT = lib.strings.toInt port;
        ROOT_URL = "https://${domain}/";
        DOMAIN = domain;
      };
      service = {
        DISABLE_REGISTRATION = false;
      };
    };
  };

  services.gitea-actions-runner.instances.nix-runner = {
    enable = true;
    labels = ["native:host"];
    hostPackages = with pkgs; [
      bash
      cargo
      coreutils
      curl
      gawk
      gitMinimal
      gnused
      wget
      node
      nix
    ];
    name = config.networking.hostName;
    url = "https://${domain}";
    tokenFile = config.secrets.butters.gitea_runner;
  };

  # DNS
  services.local_dns.service_map = {
    ${name} = "butters";
  };

  # Reverse proxy
  services.traefik.dynamicConfigOptions = {
    http.routers.${name} = {
      rule = "Host(`${domain}`)";
      service = name;
      tls = { };
    };
    http.services.${name}.loadBalancer.servers = [{
      url = "http://localhost:${port}";
    }];
  };

  # Backups
  services.restic.backups.cartman = {
    paths = [ dataVolume ];
  };
}
