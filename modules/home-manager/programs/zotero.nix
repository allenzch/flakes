{ config, lib, pkgs, ... }:
with lib; let cfg = config.custom.programs.zotero;
in {
  options.custom.programs.zotero = {
    enable = mkEnableOption "zotero";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zotero-beta
    ];
    envPersist.directories = [
      ".zotero" 
      "Zotero" 
    ];
  };
}
