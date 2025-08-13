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
}
