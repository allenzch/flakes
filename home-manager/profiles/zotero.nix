{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zotero-beta
  ];
  envPersist.directories = [
    ".zotero" 
    "Zotero" 
  ];
}
