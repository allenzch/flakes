{ config, lib, mypkgs, ... }:
with lib; let
  cfg = config.custom.programs.texmacs;
in {
  options.custom.programs.texmacs = {
    enable = mkEnableOption "TeXmacs";
    package = mkPackageOption mypkgs "texmacs" { };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
    home.file.".TeXmacs" = {
      source = ./TeXmacs;
      recursive = true;
    };
  };
}
