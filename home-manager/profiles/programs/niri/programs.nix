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
    swww
    waybar
    fuzzel
    swaylock
    kitty
    firefox
    fcitx5
  ];

  misc.gtk.enable = true;

  home.sessionVariables.NIXOS_OZONE_WL = 1;
}


