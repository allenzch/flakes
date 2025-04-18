{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  allNetns = filterAttrs (name: cfg: cfg.enable) config.networking.netns;
in
{
  options.networking.netns = mkOption {
    type = types.attrsOf (
      types.submodule (
        { ... }:
        {
          options.forwardPorts = mkOption {
            type = types.listOf (
              types.submodule {
                options = {
                  protocol = mkOption {
                    type = types.enum [
                      "tcp"
                      "udp"
                    ];
                    default = "tcp";
                    description = ''
                      The protocol specifier for port forwarding between network namespaces.
                    '';
                  };
                  netnsPath = mkOption {
                    type = types.str;
                    default = "/proc/1/ns/net";
                    description = ''
                      Path to the network namespace to forward ports from.
                    '';
                  };
                  source = mkOption {
                    type = types.str;
                    description = ''
                      The source endpoint in the specified network namespace to forward.
                    '';
                  };
                  target = mkOption {
                    type = types.str;
                    description = ''
                      The target endpoint in the current network namespace to listen on.
                    '';
                  };
                  extraDependencies = mkOption {
                    type = types.listOf types.str;
                    default = [ ];
                    description = ''
                      A list of additional systemd services that must be active
                      before the port forward takes place.
                    '';
                  };
                };
              }
            );
            default = [ ];
            description = ''
              List of forwarded ports from another network namespace to this
              network namespace.
            '';
          };
        }
      )
    );
  };

  config = {
    systemd.services = listToAttrs (
      flatten (
        mapAttrsToList (
          name: cfg:
          (imap (
            index: fp:
            let
              inherit (fp)
                protocol
                source
                target
                netnsPath
                extraDependencies
                ;
            in
            nameValuePair "netns-${name}-port-forward-${toString index}" {
              serviceConfig = {
                Type = "simple";
                Restart = "on-failure";
                RestartSec = 5;
                ExecStart = "${pkgs.netns-proxy}/bin/netns-proxy ${netnsPath} ${source} -b ${target} -p ${protocol} -v";
                NetworkNamespacePath = cfg.netnsPath;
              };
              after = [
                "netns-${name}.service"
              ] ++ extraDependencies;
              partOf = [
                "netns-${name}.service"
              ] ++ extraDependencies;
              requires = [
                "netns-${name}.service"
              ] ++ extraDependencies;
              wantedBy = [
                "netns-${name}.service"
                "multi-user.target"
              ] ++ extraDependencies;
            }
          ) cfg.forwardPorts)
        ) allNetns
      )
    );
  };
}
