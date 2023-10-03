{ pkgs, ... }:
{
  containers.lan-dns = {
    autoStart = true;
    ephemeral = true;
    macvlans = ["enp2s0"];
    #extraFlags = ["-U"]; # private user namespace
    config = {config, pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        lshw
        dig
      ];
      environment.etc."resolv.conf".text = "";
      environment.etc."unbound/rpz.home.arpa".text = ''
        $ORIGIN rpz.home.arpa.

        butters IN CNAME butters.home.arpa.
        cartman IN CNAME cartman.home.arpa.
        dash    IN CNAME butters.home.arpa.
        nas     IN CNAME cartman.home.arpa.
      '';
      services.unbound = {
        enable = true;
        settings = {
          server = {
            verbosity = 3;
            module-config = ''"respip validator iterator"'';
            interface = [
              "127.0.0.1"
              "::1"
            ];
            access-control = [
              "127.0.0.0/8 allow"
              "192.168.1.0/24 allow"
            ];
            local-zone = [
              ''"home.arpa." nodefault''
              ''"1.168.192.in-addr.arpa" nodefault''
            ];
            #local-data = [
            #  ''"dash CNAME butters.home.arpa."''
            #  ''"nas CNAME cartman.home.arpa."''
            #];
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
              forward-addr = "1.1.1.1";
            }
          ];
          rpz = {
            name = "rpz.home.arpa";
            zonefile = "/etc/unbound/rpz.home.arpa";
            rpz-log = true;
          };
        };
      };
#      services.dnsmasq = {
#        enable = true;
#        resolveLocalQueries = false;
#        settings = {
#          #domain-needed = true;
#          #bogus-priv = true;
#          no-hosts = true;
#          no-resolv = true;
#          server = [
#            "192.168.1.1"
#          ];
#          expand-hosts = false;
#          cname = [
#            "dash,butters"
#            "nas,cartman"
#          ];
#          port = 53;
#          log-dhcp = true;
#          log-queries = true;
#          dns-loop-detect = true;
#        };
#      };
      networking = {
        hostName = "lan-dns";
        interfaces."mv-enp2s0" = {
          useDHCP = true;
        };
        resolvconf.enable = false;
        useHostResolvConf = false;
        firewall.allowedUDPPorts = [ 53 ];
        search = [];
        nameservers = [];
      };
    };
  };
}
