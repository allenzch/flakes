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
    layers = {
      desktopBase.enable = true;
    };
    programs = {
      zotero.enable = true;
      logseq.enable = true;
      vscode.enable = true;
      telegram.enable = true;
    };
  };
  envPersist.directories = [
    ".local"
    ".ssh"
    ".steam"
  ];
}