{ pkgs, data, homeProfiles, ... }: {
  imports =
    (with homeProfiles.programs; [
      direnv
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
      misc.theme-catppuccin
      misc.font-noto
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

  custom = {
    i18n.fcitx5 = {
      enable = true;
      plasma6Support = true;
      withConfigtool = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
      ];
    };
  };

  persistence.directories = [
    ".local"
    ".ssh"
    "main"
  ];
}
