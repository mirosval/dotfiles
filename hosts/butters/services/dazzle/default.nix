{ lib, pkgs, ... }:
let
  name = "dazzle";
  port = "5007";
  domain = "${name}.doma.lol";
  giteauid = 63182;
in
{
  users.users.gitea-runner = {
    uid = giteauid;
  };

  users.groups.gitea-runner = {
    gid = giteauid;
  };

  system.activationScripts = {
    makeDazzleContainerDir = lib.stringAfter [ "var" ] ''
      mkdir -p /tmp/podman-deploy
      chown gitea-runner:gitea-runner /tmp/podman-deploy
      chmod u+rwX /tmp/podman-deploy
    '';
  };

  systemd.services.dazzle-watcher = {
    description = "Watcher for the weather service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${./watcher.sh} ${name} ${port}";
      Restart = "always";
    };
    path = with pkgs; [
      bash
      jq
      podman
    ];
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
    http.services.${name}.loadBalancer.servers = [
      {
        url = "http://localhost:${port}";
      }
    ];
  };
}
