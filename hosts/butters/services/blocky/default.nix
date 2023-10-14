{ pkgs, ... }:
{
  containers.blocky = {
    autoStart = true;
    ephemeral = true;
    macvlans = [ "enp2s0" ];
    privateNetwork = false;
    config = { config, pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        lshw
        dig
        nmap
      ];
      services.blocky = {
        enable = true;
        settings = {
          log = {
            level = "debug";
          };
          upstreams = {
            groups = {
              "default" = [
                "https://dns.google/dns-query"
                "https://1.1.1.1/dns-query"
                "https://1.0.0.1/dns-query"
                "https://dns.quad9.net/dns-query"
                "https://doh.opendns.com/dns-query"
              ];
            };
          };
          bootstrapDns = [
            "tcp+udp:1.1.1.1"
            "https://1.1.1.1/dns-query"
            "https://1.0.0.1/dns-query"
          ];
          blocking = {
            blackLists = {
              ads = [
                "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
              ];
            };
            clientGroupsBlock = {
              "default" = [
                "ads"
              ];
            };
          };
          ports = {
            dns = "192.168.1.4:53";
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
              "192.168.1.4/24"
            ];
            networkConfig.DHCP = "yes";
            dhcpV4Config.ClientIdentifier = "mac";
          };
        };
      };
    };
  };
}
