_:
let
  butters_addr = "192.168.1.214";
  cartman_addr = "192.168.1.252";
  butters_ts_addr = "100.87.221.130";
  cartman_ts_addr = "100.120.139.6";
in
{
  services.local_dns = {
    enable = true;
    local_domain = "doma.lol";
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
      jellyfin = "butters";
      linkding = "butters";
      mealie = "butters";
      traefik = "butters";
    };
  };
}
