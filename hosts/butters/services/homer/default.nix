{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    homer = {
      image = "b4bz/homer";
      autoStart = true;
      ports = ["127.0.0.1:4000:8080"];
    };
  };
}
