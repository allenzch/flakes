{ pkgs, data, homeProfiles, ... }: {
  imports =
    (with homeProfiles.programs; [
      direnv
      fish
      git
      htop
      neovim
      syncthing
      yazi
      zoxide

      niri
      libreoffice
      logseq
      telegram
      zotero
    ]) ++
    (with homeProfiles; [
      theme.adwaiccin
      font.noto
    ]);

  home.packages = with pkgs; [
    apostrophe
    comma-with-db
  ];

  programs.bash.enable = true;


  persistence.directories = [
    ".local"
    ".ssh"
    "main"
  ];
}
