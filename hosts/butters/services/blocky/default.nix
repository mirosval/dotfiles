{ pkgs, ... }:
{
  services.blocky = {
    enable = false;
    settings = {
      log = {
        level = "debug";
      };
      upstreams = {
        groups = {
          "default" = [
            "127.0.0.1:54" # dnsmasq
          ];
        };
      };
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
          "100.0.0.0/8" = [
            "ads"
          ];
          "192.168.0.0/16" = [
            "ads"
          ];
        };
      };
      ports = {
        dns = 53;
        http = 4000;
      };
    };
  };
}
