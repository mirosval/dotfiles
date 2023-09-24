{ ... }: {
  imports = [
    ./services
  ];
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    oci-containers.backend = "podman";
  };
}
