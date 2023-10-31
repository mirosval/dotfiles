{ inputs, lib, ... }:
let
  butters_addr = "192.168.1.214";
  cartman_addr = "192.168.1.252";
  butters_ts_addr = "100.87.221.130";
  cartman_ts_addr = "100.120.139.6";
  view_map = {
    lan = {
      butters = butters_addr;
      cartman = cartman_addr;
    };
    tailscale = {
      butters = butters_ts_addr;
      cartman = cartman_ts_addr;
    };
  };
  service_map = {
    butters = "butters";
    cartman = "cartman";
    dash = "butters";
    grafana = "butters";
    immich = "butters";
    linkding = "butters";
    mealie = "butters";
    traefik = "butters";
  };
  # This converts the map of service -> hostname to DNS A records
  # view: can be either "lan" or "tailscale"
  mkLocalData = view: lib.attrValues (
    lib.mapAttrs
      (service: host:
        ''"${service}.doma.lol. IN A ${view_map.${view}.${host}}"''
      )
      service_map
  );
in
{
  imports = [
    inputs.blocklist.nixosModules.default
  ];
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
        module-config = ''"respip validator iterator"'';
        interface = [
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
          ''"doma.lol." static''
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
        private-domain = ''"doma.lol."'';
        domain-insecure = ''"doma.lol."'';
      };
      view = {
        name = "tailscale";
        local-zone = [
          ''"doma.lol." static''
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
        name = ''"doma.lol"'';
        stub-addr = "192.168.1.1";
        stub-first = "yes";
      };
      forward-zone = [
        {
          name = ''"."'';
          forward-addr = [
            "1.1.1.1"
            "1.0.0.1"
            "8.8.8.8"
            "8.8.4.4"
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
