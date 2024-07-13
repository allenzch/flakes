{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.custom.programs.logseq;
  # logseq-catppuccin = with pkgs; stdenv.mkDerivation {
  #   pname = "logseq-catppuccin";
  #   version = "v0.6.3";
  #   src = fetchzip {
  #     url = "https://github.com/catppuccin/logseq/releases/download/v0.6.3/logseq-catppuccin-v0.6.3.zip";
  #     sha256 = "sha256-sW3dIKyiWd5xmlQcs7IjZrOKycQnINBe7gLPcZmnIVs=";
  #   };
  #   installPhase = ''
  #     find . -type f -exec install -Dm 644 {} "$out/"{} \;
  #   '';
  # };
in {
  options.custom.programs.logseq = {
    enable = mkEnableOption "logseq";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ logseq ];
    envPersist.directories = [
      ".logseq"
      ".config/Logseq"
    ];
  };
}