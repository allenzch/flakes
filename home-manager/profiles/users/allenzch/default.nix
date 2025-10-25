{ pkgs, data, homeProfiles, ... }: {
  imports =
    (with homeProfiles.programs; [
      direnv
      fcitx5
      fish
      yazi
      htop
      neovim
      logseq
      vscode
      telegram
      texmacs
      syncthing
      zotero
    ]) ++
    (with homeProfiles; [
      desktop-environments.niri-default
      themes.adwaiccin
      fontconfig.noto
    ]);

  home.packages = with pkgs; [
    apostrophe
  ];

  programs.bash.enable = true;

  programs.git = {
    enable = true;
    userName = data.git.userName;
    userEmail = data.git.userEmail;
    signing.key = "~/.ssh/id_ed25519";
    extraConfig = {
      commit.gpgSign = true;
      gpg = {
        format = "ssh";
      };
      init.defaultBranch = "master";
    };
  };

  persistence.directories = [
    ".local"
    ".ssh"
    "main"
  ];
}
