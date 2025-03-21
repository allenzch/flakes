{ config, pkgs, ... }:
let
  theme = config.custom.misc.theme;
in {
  programs.waybar = {
    enable = true;
    settings = [ (import ./waybar.nix { inherit config pkgs; }) ];
    style = import ./style.nix { inherit theme; };
    systemd.enable = true;
  };
}
