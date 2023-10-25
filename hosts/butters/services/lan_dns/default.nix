{ inputs, ... }:
let
  butters_addr = "192.168.1.214";
  cartman_addr = "192.168.1.252";
in
{
  containers.lan-dns = {
    autoStart = true;
    ephemeral = true;
    macvlans = [ "enp2s0" ];
    privateNetwork = false;
    extraVeths = {
      # This is for promtail to be able to ship logs to host
      veth1 = {
        hostAddress = "192.168.2.1";
        localAddress = "192.168.2.2";
      };
    };
    #extraFlags = ["-U"]; # private user namespace
    config = { pkgs, ... }: {
      imports = [
        inputs.blocklist.nixosModules.default
      ];
      environment.systemPackages = with pkgs; [
        lshw
        dig
        nmap
      ];
      services.unbound = {
        enable = true;
        resolveLocalQueries = false;
        blocklist.enable = true;
        settings = {
          remote-control = {
            control-enable = true;
          };
          server = {
            verbosity = 0;
            log-queries = "yes";
            log-replies = "yes";
            log-tag-queryreply = "yes";
            log-local-actions = "yes";
            log-servfail = "yes";
            extended-statistics = "yes";
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
              ''"lan.zoricak.net." static''
              # ''"168.192.in-addr.arpa." nodefault''
            ];
            local-data = [
              ''"butters.lan.zoricak.net.  IN A ${butters_addr}"''
              ''"cartman.lan.zoricak.net.  IN A ${cartman_addr}"''
              ''"dash.lan.zoricak.net.     IN A ${butters_addr}"''
              ''"grafana.lan.zoricak.net.  IN A ${butters_addr}"''
              ''"linkding.lan.zoricak.net. IN A ${butters_addr}"''
              ''"traefik.lan.zoricak.net.  IN A ${butters_addr}"''
            ];
            private-domain = ''"lan.zoricak.net."'';
            domain-insecure = ''"lan.zoricak.net."'';
          };
          stub-zone = {
            name = ''"lan.zoricak.net"'';
            stub-addr = "192.168.1.1";
            stub-first = "yes";
          };
          forward-zone = [
            # {
            #   name = ''"lan.zoricak.net."'';
            #   forward-addr = "192.168.1.1";
            #   # forward-first = "yes";
            # }
            {
              name = ''"."'';
              forward-addr = [
                "1.1.1.1"
                "1.0.0.1"
                "8.8.8.8"
                "8.8.4.4"
              ]; # hosts/butters/services/blocky
            }
          ];
        };
      };
      services.prometheus.exporters.unbound = {
        enable = true;
        openFirewall = true;
        listenAddress = "192.168.2.2";
      };
      systemd.services.promtail = {
        description = "Promtail service for lan_dns";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = ''
            ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
          '';
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
