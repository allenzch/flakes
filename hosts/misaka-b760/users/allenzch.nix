{ config, pkgs, mylib, mypkgs, data, ... }: {
  home.packages = with pkgs; [
    julia-bin
    hugo
  ];
  programs.bash.enable = true;
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