{ config, lib, ... }: {
  systemd.network = {
    enable = true;
    # silly fix for the service failing on nixos rebuild
    wait-online.enable = lib.mkForce false;
    networks = {
      "40-enp2s0" = {
        matchConfig.Name = "enp2s0";
        networkConfig.DHCP = "yes";
      };
    };
  };

  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--ssh" ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.resolved = {
    enable = true;
    domains = [
      "doma.lol"
    ];
  };

  networking = {
    hostName = "butters"; # Define your hostname.
    networkmanager.enable = false;
    useNetworkd = true;
    nameservers = [
      "127.0.0.1"
    ];

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [
        config.services.tailscale.port
        53 # DNS (blocky) 
      ];
      allowedTCPPorts = [
        22 # SSH
        80 # HTTP (Traefik)
        443 # HTTPS (Traefik)
        3100 # Loki
        4000 # DoH (blocky)
        8080 # Traefik management
      ];
    };
  };
}
