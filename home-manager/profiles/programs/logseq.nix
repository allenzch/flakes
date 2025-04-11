{ pkgs, ... }:
let
  logseq-wrapped = pkgs.symlinkJoin {
    name = "logseq";
    paths = [ pkgs.logseq ];
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/logseq" \
        --add-flags '--wayland-text-input-version=3'
    '';
  };
in
{
  home.packages = [
    logseq-wrapped
  ];
  envPersist.directories = [
    ".logseq"
    ".config/Logseq"
  ];
}
