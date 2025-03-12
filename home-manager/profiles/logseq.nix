{ pkgs-stable, ... }:
{
  home.packages = [
    pkgs-stable.logseq
  ];
  envPersist.directories = [
    ".logseq"
    ".config/Logseq"
  ];
}
