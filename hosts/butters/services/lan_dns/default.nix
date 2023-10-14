{ pkgs, ... }:
{
  containers.lan-dns = {
    autoStart = true;
    ephemeral = true;
    macvlans = [ "enp2s0" ];
    privateNetwork = false;
    #extraFlags = ["-U"]; # private user namespace
    config = { config, pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        lshw
        dig
        nmap
      ];
      environment.etc."unbound/rpz.home.arpa".text = ''
        $ORIGIN rpz.home.arpa.

        butters IN CNAME butters.home.arpa.
        cartman IN CNAME cartman.home.arpa.
        dash    IN CNAME butters.home.arpa.
        nas     IN CNAME cartman.home.arpa.
      '';
      services.unbound = {
        enable = true;
        resolveLocalQueries = false;
        settings = {
          server = {
            verbosity = 3;
            module-config = ''"respip validator iterator"'';
            interface = [
              "mv-enp2s0"
            ];
            access-control = [
              "127.0.0.0/8 allow"
              "192.168.1.0/24 allow"
            ];
            local-zone = [
              ''"home.arpa." nodefault''
              ''"1.168.192.in-addr.arpa" nodefault''
            ];
            private-domain = ''"home.arpa."'';
            domain-insecure = ''"home.arpa."'';
          };
          stub-zone = {
            name = "home.arpa.";
            stub-addr = "192.168.1.1@53";
          };
          forward-zone = [
            {
              name = ".";
              forward-addr = "192.168.1.4"; # hosts/butters/services/blocky
            }
          ];
          rpz = {
            name = "rpz.home.arpa";
            zonefile = "/etc/unbound/rpz.home.arpa";
            rpz-log = true;
          };
        };
      };
      networking = {
        useDHCP = false;
        useNetworkd = true;
        useHostResolvConf = false;
        firewall = {
          enable = true;
          interfaces."mv-enp2s0".allowedUDPPorts = [ 53 ];
        };
      };
      systemd.network = {
        enable = true;
        networks = {
          "40-mv-enp2s0" = {
            matchConfig.Name = "mv-enp2s0";
            address = [
              "192.168.1.3/24"
            ];
            networkConfig.DHCP = "yes";
            dhcpV4Config.ClientIdentifier = "mac";
          };
        };
      };
    };
  };
}
