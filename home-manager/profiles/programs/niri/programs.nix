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
    noctalia-shell
    kitty
    firefox
    fcitx5
  ];

  misc.gtk.enable = true;

  home.sessionVariables.NIXOS_OZONE_WL = 1;
}


