{ pkgs, homeProfiles, ... }:
{
  home.packages = with pkgs; [
    nautilus
    file-roller
    loupe
    papers
    mpv
  ];

  imports = with homeProfiles.programs; [
    darkman
    noctalia-shell
    kitty
    firefox
    fcitx5
    gtk
  ];


  home.sessionVariables.NIXOS_OZONE_WL = 1;
}


