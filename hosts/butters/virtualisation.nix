_: {
  imports = [
    ./services
  ];
  virtualisation = {
    #vlans = [ 1 ];
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = false;
      };
    };
    oci-containers.backend = "podman";
    containers = {
      enable = true;
    };
  };

  #  systemd.services.create-podman-network = {
  #    serviceConfig.Type = "oneshot";
  #    wantedBy = ["podman-homer.service"];
  #    script = ''
  #      ${pkgs.podman}/bin/podman network exists homelab_network || \
  #        ${pkgs.podman}/bin/podman network create --driver=macvlan --gateway=192.168.1.1 --subnet=192.168.1.0/24 -o parent=enp2s0 homelab_network
  #    '';
  #  };
}
