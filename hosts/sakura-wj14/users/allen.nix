{ config, pkgs, mylib, mypkgs, data, ... }: {
  home.packages = with pkgs; [
    julia-bin
    hugo
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
    programs = {
      zotero.enable = true;
      logseq.enable = true;
      vscode.enable = true;
      telegram.enable = true;
      direnv.enable = true;
      fish.enable = true;
      yazi.enable = true;
      htop.enable = true;
      neovim.enable = true;
    };
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
