{ pkgs, data, homeProfiles, ... }: {
  imports =
    (with homeProfiles.programs; [
      direnv
      fish
      htop
      neovim
      syncthing
      yazi
      zoxide

      niri
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

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = data.git.userName;
        email = data.git.userEmail;
      };
      commit.gpgSign = true;
      init.defaultBranch = "master";
    };
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519";
    };
  };

  persistence.directories = [
    ".local"
    ".ssh"
    "main"
  ];
}
