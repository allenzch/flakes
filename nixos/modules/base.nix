{ lib, ... }:
let
  inherit (lib) mkDefault;
in {
  system.stateVersion = "23.11";

  nix.enable = mkDefault false;

  security.sudo.enable = mkDefault false;
}
