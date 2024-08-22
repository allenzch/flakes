{ config, lib, ... }:
with lib; let cfg = config.custom.virtualisation.podman;
in {
  options.custom.virtualisation.podman = {
    enable = mkEnableOption "podman";
  };
  config = mkIf cfg.enable {
    virtualisation.podman.enable = true;
  };
}
