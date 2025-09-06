{ lib, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    clusterInit = true;
    extraFlags = lib.mkAfter [
      "--write-kubeconfig-mode=644"
    ];
  };
}
