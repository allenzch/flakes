{ pkgs, ... }:
{
  home.packages = with pkgs; [ libreoffice ];

  persistence.directories = [ ".config/libreoffice" ];
}
