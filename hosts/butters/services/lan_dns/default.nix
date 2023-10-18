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
      environment.etc."unbound/rpz.lan.zoricak.net".text = ''
        $ORIGIN rpz.lan.zoricak.net.

        butters                 IN AAAA ::1
        butters.lan.zoricak.net IN AAAA ::1
        butters                 IN CNAME butters.lan.zoricak.net.
        cartman                 IN CNAME cartman.lan.zoricak.net.
        dash                    IN CNAME butters.lan.zoricak.net.
        grafana                 IN CNAME butters.lan.zoricak.net.
        grafana.lan.zoricak.net IN CNAME butters.lan.zoricak.net.
        nas                     IN CNAME cartman.lan.zoricak.net.
        linkding                IN CNAME butters.lan.zoricak.net.
      '';
      services.unbound = {
        enable = true;
        resolveLocalQueries = false;
        settings = {
          server = {
            verbosity = 3;
            log-queries = "yes";
            module-config = ''"respip validator iterator"'';
            interface = [
              "mv-enp2s0"
            ];
            access-control = [
              "127.0.0.0/8 allow"
              "192.168.1.0/24 allow"
            ];
            do-ip6 = "yes";
            local-zone = [
              ''"lan.zoricak.net." transparent''
              ''"168.192.in-addr.arpa." transparent''
            ];
            # local-data = [
            #   ''"butters.lan.zoricak.net. IN AAAA ::1"''
            #   ''"grafana.lan.zoricak.net. IN AAAA ::1"''
            #   ''"grafana.lan.zoricak.net. IN A butters.lan.zoricak.net."''
            #   #   ''"butters.lan.zoricak.net. IN A 192.168.1.214"''
            #   #   ''"cartman.lan.zoricak.net. IN A 192.168.1.252"''
            #   #   ''"grafana.lan.zoricak.net. IN A 192.168.1.214"''
            #   #   ''"grafana.lan.zoricak.net. IN AAAA ::1"''
            #   #   ''"dash.lan.zoricak.net. IN A 192.168.1.214"''
            #   #   ''"traefik.lan.zoricak.net. IN A 192.168.1.214"''
            # ];
            private-domain = ''"lan.zoricak.net."'';
            domain-insecure = ''"lan.zoricak.net."'';
          };
          stub-zone = {
            name = ''"lan.zoricak.net."'';
            stub-addr = "192.168.1.1";
            #stub-first = "yes";
          };
          forward-zone = [
            {
              name = ''"lan.zoricak.net."'';
              forward-addr = "192.168.1.1";
              # forward-first = "yes";
            }
            # {
            #   name = ''"168.192.in-addr.arpa."'';
            #   forward-addr = "192.168.1.1";
            # }
            {
              name = ".";
              forward-addr = "192.168.1.4"; # hosts/butters/services/blocky
            }
          ];
          rpz = {
            name = "rpz.lan.zoricak.net";
            zonefile = "/etc/unbound/rpz.lan.zoricak.net";
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
