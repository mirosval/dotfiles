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
      butters = "butters"; # map butters.doma.lol to butters_addr (or butters_ts_addr on tailscale)
      cartman = "cartman"; # map cartman.doma.lol to cartman_addr (or cartman_ts_addr on tailscale)
    };
  };
}
