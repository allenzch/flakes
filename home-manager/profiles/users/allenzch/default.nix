{ pkgs, homeProfiles, ... }: {
  imports = with homeProfiles.programs; [
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
  ];

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
