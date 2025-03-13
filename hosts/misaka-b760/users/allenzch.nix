{ config, pkgs, mylib, mypkgs, data, ... }: {
  home.packages = with pkgs; [
    julia-bin
    hugo
  ];
  imports = [
    ../../../home-manager/profiles/direnv.nix
    ../../../home-manager/profiles/fish.nix
    ../../../home-manager/profiles/yazi.nix
    ../../../home-manager/profiles/htop.nix
    ../../../home-manager/profiles/neovim
    ../../../home-manager/profiles/logseq.nix
    ../../../home-manager/profiles/vscode.nix
    ../../../home-manager/profiles/telegram.nix
    ../../../home-manager/profiles/texmacs
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
  envPersist.directories = [
    ".local"
    ".ssh"
    "main"
  ];
}
