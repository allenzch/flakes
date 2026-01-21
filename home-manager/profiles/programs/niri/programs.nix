{ pkgs, homeProfiles, ... }:
{
  home.packages = with pkgs; [
    nautilus
    file-roller
    loupe
    papers
    mpv
  ];

  imports = (with homeProfiles.programs; [
    kitty
    firefox

    darkman
    gtk
    fcitx5
    noctalia-shell
  ]) ++ (with homeProfiles; [
    theme.adwaiccin
    font.noto
  ]);

  home.sessionVariables.NIXOS_OZONE_WL = 1;
}


