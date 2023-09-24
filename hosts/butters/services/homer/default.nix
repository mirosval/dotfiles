{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    homer = {
      autoStart = true;
      image = "ghcr.io/bastienwirtz/homer";
      ports = [
        "8080:8080"
      ];
      volumes = [
        "${toString ./.}/assets:/www/assets"
      ];
    };
  };
}
