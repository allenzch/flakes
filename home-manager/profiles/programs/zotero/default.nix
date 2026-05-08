{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zotero
  ];
  persistence.directories = [
    ".zotero" 
    "Zotero" 
  ];
}
