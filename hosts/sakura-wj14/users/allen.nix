{ config, pkgs, mylib, mypkgs, data, homeProfiles, ... }: {
  imports =
    (with homeProfiles.programs; [
      direnv
      fish
      yazi
      htop
      neovim
      zotero
      logseq
      vscode
      telegram
      texmacs
    ]) ++
    (with homeProfiles; [
      desktop-environments.niri-default
      misc.font-noto
      misc.theme-catppuccin
    ]);
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
  envPersist.directories = [
    ".local"
    ".ssh"
    "main"
    ".steam"
  ];
}
