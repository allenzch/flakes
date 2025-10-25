{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zotero-beta
  ];
  persistence.directories = [
    ".zotero" 
    "Zotero" 
  ];
}
