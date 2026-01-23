{ pkgs, ... }:
{
  home.packages = with pkgs; [ libreoffice-fresh ];

  persistence.directories = [ ".config/libreoffice" ];
}
