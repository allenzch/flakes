{ mypkgs, ... }:
{
  home.packages = [
    mypkgs.texmacs
  ];
  home.file.".TeXmacs" = {
    source = ./TeXmacs;
    recursive = true;
  };
}
