{ config, lib, nixosProfiles, ... }:
{
  imports = with nixosProfiles; [
    services.enthalpy
    services.resolved
  ];

  services.enthalpy = {
    prefix = "2a0e:aa07:e21d:2610::/60";
    ipsec.interfaces = [ "brwan" ];
    clat = {
      enable = true;
      segment = lib.singleton "2a0e:aa07:e21c:2546::3";
    };
    srv6.enable = true;
  };

  systemd.services.nix-daemon = config.networking.netns.enthalpy.config;

  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;
    config = {
      networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };
    netdevs = {
      "20-brwan" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "brwan";
        };
      };
    };
    networks = {
      "20-enp1s0" = {
        matchConfig.Name = "enp1s0";
        networkConfig = {
          DHCPServer = "yes";
          IPv6SendRA = "yes";
          IPv6PrivacyExtensions = true;
          IPv6AcceptRA = "no";
          KeepConfiguration = true;
        };
        dhcpServerConfig = {
          ServerAddress = "100.64.0.1/20";
          EmitDNS = true;
          DNS = "10.10.0.21";
        };
        ipv6Prefixes = lib.singleton {
          Prefix = "fd12:4a69:cc19:252f::/64";
          Assign = true;
        };
      };
      "20-enp3s0" = {
        matchConfig.Name = "enp3s0";
        bridge = [ "brwan" ];
      };
      "30-brwan" = {
        matchConfig.Name = "brwan";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
          KeepConfiguration = true;
        };
        dhcpV4Config.RouteMetric = 1024;
        dhcpV6Config.RouteMetric = 1024;
        ipv6AcceptRAConfig.RouteMetric = 1024;
      };
    };
  };

  networking.firewall.enable = false;

  networking.nftables = {
    enable = true;
    tables.nat = {
      family = "inet";
      content = ''
        chain postrouting {
          type nat hook postrouting priority srcnat; policy accept;
          oifname brwan counter masquerade
        }
      '';
    };
  };
}
