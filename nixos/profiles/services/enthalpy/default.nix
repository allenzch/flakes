{
  config,
  self,
  ...
}:
{
  sops.secrets = {
    "enthalpy-private-key-pem/allenzch" = {
      sopsFile = "${self}/secrets/local.yaml";
    };
  };
  services.enthalpy = {
    enable = true;

    ipsec = {
      organization = "allenzch's network";
      endpoints = [
        {
          serialNumber = "0";
          addressFamily = "ip4";
        }
        {
          serialNumber = "1";
          addressFamily = "ip6";
        }
      ];
      privateKeyPath = config.sops.secrets."enthalpy-private-key-pem/allenzch".path;
    };
  };

  networking.netns.enthalpy.confext."machine-id".source = "/persist/etc/machine-id";

  networking.netns.enthalpy.nftables.tables = {
    filter6 = {
      family = "ip6";
      content = ''
        chain input {
          type filter hook input priority filter; policy accept;
          iifname "enta*" ct state established,related counter accept
          iifname "enta*" ip6 saddr { fe80::/64, 2a0e:aa07:e21c::/47 } counter accept
          iifname "enta*" counter drop
        }

        chain output {
          type filter hook output priority filter; policy accept;
          oifname "enta*" ip6 daddr != { fe80::/64, 2a0e:aa07:e21c::/47 } \
            icmpv6 type time-exceeded counter drop
        }
      '';
    };
  };
}
