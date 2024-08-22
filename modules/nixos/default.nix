{ config, lib, mylib, ... }:
with lib; {
  imports = mylib.getItemPaths ./. "default.nix";
  security.sudo.enable = mkDefault false;
  system.stateVersion = "23.11";
}
