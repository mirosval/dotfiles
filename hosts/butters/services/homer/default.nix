_:
{
  virtualisation.oci-containers.containers = {
    homer = {
      autoStart = true;
      image = "ghcr.io/bastienwirtz/homer";
      ports = [
        "8081:8080"
      ];
      volumes = [
        "${toString ./.}/assets:/www/assets"
      ];
      extraOptions = [
        "--name=homer"
        "--hostname=homer"
      ];
    };
  };
}
