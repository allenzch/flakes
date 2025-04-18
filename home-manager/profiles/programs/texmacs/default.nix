{ pkgs, ... }:
{
  home.packages = [
    pkgs.texmacs-mod
  ];
  home.file.".TeXmacs" = {
    source = ./TeXmacs;
    recursive = true;
  };
}
