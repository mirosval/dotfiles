{ inputs, lib, config, ... }:
let
  cfg = config.services.local_dns;
in
{
  imports = [
    inputs.blocklist.nixosModules.default
  ];
  options.services.local_dns = {
    enable = lib.mkEnableOption "Local DNS";
    local_domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain to use to create the local zone";
      example = "example.com";
    };
    view_map = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      description = ''
        Split-horizon view mapping of DNS A records
        The first level is the view name, lan or tailscale.
        The second level is the host to IP mapping that will create
        A records like for LAN:
        host_a.$${local_domain}. IN A 10.0.0.1

        And for Tailscale:
        host_a.$${local_domain}. IN A 100.0.0.1
      '';
      example = ''
        view_map = {
          lan = {
            host_a = "10.0.0.1";
            host_a = "10.0.0.2";
          };
          tailscale = {
            host_a = "100.0.0.1";
            host_a = "100.0.0.2";
          };
        };
      '';
    };
    service_map = lib.mkOption {
      type = lib.types.attrsOf (lib.types.str);
      description = ''
        Map of hosts in terms of the hosts defined in the view_map.

        This works like CNAME records, but it resolves directly to
        the IP addresses defined in the view_map.
      '';
      example = ''
        service_map = {
          host_c = "host_a";
        };
      '';
    };
  };
  config = lib.mkIf cfg.enable (
    let

      # This converts the map of service -> hostname to DNS A records
      # view: can be either "lan" or "tailscale"
      mkLocalData = view: lib.attrValues (
        lib.mapAttrs
          (service: host:
            ''"${service}.${cfg.local_domain}. IN A ${cfg.view_map.${view}.${host}}"''
          )
          cfg.service_map
      );
    in
    {
      services.unbound = {
        enable = true;
        resolveLocalQueries = true;
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
            tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";
            module-config = ''"respip validator iterator"'';
            interface = [
              "127.0.0.1"
              "enp2s0"
              "tailscale0"
            ];
            interface-view = "tailscale0 tailscale";
            access-control = [
              "127.0.0.0/8 allow" # Local
              "192.168.1.0/24 allow" # LAN
              "100.0.0.0/8 allow" # Tailscale
            ];
            access-control-view = "100.0.0.0/8 tailscale";
            do-ip6 = "yes";
            local-zone = [
              ''"${cfg.local_domain}." static''
            ];
            local-data = mkLocalData "lan";
            # local-data = [
            #   ''"butters.doma.lol.  IN A ${butters_addr}"''
            #   ''"cartman.doma.lol.  IN A ${cartman_addr}"''
            #   ''"dash.doma.lol.     IN A ${butters_addr}"''
            #   ''"grafana.doma.lol.  IN A ${butters_addr}"''
            #   ''"immich.doma.lol.   IN A ${butters_addr}"''
            #   ''"linkding.doma.lol. IN A ${butters_addr}"''
            #   ''"traefik.doma.lol.  IN A ${butters_addr}"''
            # ];
            private-domain = ''"${cfg.local_domain}."'';
            domain-insecure = ''"${cfg.local_domain}."'';
          };
          view = {
            name = "tailscale";
            local-zone = [
              ''"${cfg.local_domain}." static''
            ];
            local-data = mkLocalData "tailscale";
            # local-data = [
            #   ''"butters.doma.lol.  IN A ${butters_ts_addr}"''
            #   ''"cartman.doma.lol.  IN A ${cartman_ts_addr}"''
            #   ''"dash.doma.lol.     IN A ${butters_ts_addr}"''
            #   ''"grafana.doma.lol.  IN A ${butters_ts_addr}"''
            #   ''"immich.doma.lol.   IN A ${butters_ts_addr}"''
            #   ''"linkding.doma.lol. IN A ${butters_ts_addr}"''
            #   ''"traefik.doma.lol.  IN A ${butters_ts_addr}"''
            # ];
          };
          stub-zone = {
            name = ''"${cfg.local_domain}"'';
            stub-addr = "192.168.1.1";
            stub-first = "yes";
          };
          forward-zone = [
            {
              name = ''"."'';
              forward-tls-upstream = "yes";
              forward-addr = [
                # Cloudflare
                "1.1.1.1@853#cloudflare-dns.com"
                "1.0.0.1@853#cloudflare-dns.com"
                # "2606:4700:4700::1111@853#cloudflare-dns.com"
                # "2606:4700:4700::1001@853#cloudflare-dns.com"

                # Quad9
                "9.9.9.9@853#dns.quad9.net"
                "149.112.112.112@853#dns.quad9.net"
                # "2620:fe::9@853#dns.quad9.net"
                # "2620:fe::fe@853#dns.quad9.net"
              ];
            }
          ];
        };
      };
      services.prometheus.exporters.unbound = {
        enable = true;
        listenAddress = "127.0.0.1";
      };
    }
  );
}
