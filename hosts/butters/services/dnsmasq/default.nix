{ config, pkgs, ... }: {
  services.dnsmasq = {
    enable = true;
    settings = {
      domain-needed = false;
      bogus-priv = false;
      no-hosts = true;
      no-resolv = true;
      server = [
        "/lan/192.168.1.1"
        "/boreal-scala.ts.net/100.100.100.100"
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "8.8.4.4"
        #"100.100.100.100"
      ];
      #local = "/lan/";
      expand-hosts = true;
      #domain = "lan";
      #cname = [
      #  "dash,butters.boreal-scala.ts.net"
      #  "nas,cartman.boreal-scala.ts.net"
      #];
      port = 54;
      log-dhcp = true;
      log-queries = true;
      dns-loop-detect = true;
    };
  };
}
