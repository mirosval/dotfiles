{ config, ... }:
let
  name = "traefik";
in
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "admin@doma.lol";
      dnsResolver = "1.1.1.1:53";
    };
    certs."doma.lol" = {
      domain = "doma.lol";
      group = "traefik";
      extraDomainNames = [ "*.doma.lol" ];
      dnsProvider = "porkbun";
      credentialsFile = config.secrets.butters.lets_encrypt;
    };
  };

  # DNS
  services.local_dns.service_map = {
    ${name} = "butters";
  };

  services.traefik = {
    enable = true;
    staticConfigOptions = {
      api = {
        insecure = true;
        dashboard = true;
      };
      entryPoints = {
        http = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "https";
            scheme = "https";
          };
        };
        https = {
          address = ":443";
          http.tls.domains = [{
            main = "doma.lol";
            sans = [ "*.doma.lol" ];
          }];
        };
      };
      log = {
        level = "INFO";
        format = "json";
      };
      accessLog = {
        format = "json";
        fields = {
          defaultMode = "keep";
          headers = {
            defaultMode = "keep";
          };
        };
      };
    };

    dynamicConfigOptions = {
      tls = {
        stores.default.defaultCertificate = {
          certFile = "/var/lib/acme/doma.lol/cert.pem";
          keyFile = "/var/lib/acme/doma.lol/key.pem";
        };
        certificates = [
          {
            certFile = "/var/lib/acme/doma.lol/cert.pem";
            keyFile = "/var/lib/acme/doma.lol/key.pem";
            stores = [ "default" ];
          }
        ];
      };
    };
  };
}
