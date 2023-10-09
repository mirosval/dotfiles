{ config, lib, ... }: {
  networking.hostName = "butters"; # Define your hostname.
  networking.networkmanager.enable = false;
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks = {
      "40-enp2s0" = {
        matchConfig.Name = "enp2s0";
        networkConfig.DHCP = "yes";
      };
    };
  };

  # silly fix for the service failing on nixos rebuild
  systemd.network.wait-online.enable = lib.mkForce false;

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

  networking.firewall = {
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
      4000 # DoH (blocky)
      8080 # Traefik management
    ];
  };

}
