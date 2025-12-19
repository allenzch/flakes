{ lib, ... }:
let
  inherit (lib) mkDefault;
in {
  system.stateVersion = "23.11";

  networking = {
    useDHCP = mkDefault false;
    useNetworkd = mkDefault true;
  };

  nix.enable = mkDefault false;

  programs.nano.enable = mkDefault false;

  services.logrotate.enable = mkDefault false;

  security.sudo.enable = mkDefault false;
}
