{ pkgs }:
with pkgs;
(texmacs.overrideAttrs (fianl: prev: let
  chineseFontsSrc = fetchurl {
    url = "https://ftp.texmacs.org/TeXmacs/fonts/TeXmacs-chinese-fonts.tar.gz";
    sha256 = "0yprqjsx5mfsaxr525mcm3xqwcadzxp14njm38ir1325baada2fp";
  };
  postPatch = (if texliveSmall != null then ''
    gunzip < ${chineseFontsSrc} | (cd TeXmacs && tar xvf -)
  '' else "");
in {
  patches = [ ./texmacs.patch ];
  postPatch = postPatch + ''
    substituteInPlace configure \
    --replace "-mfpmath=sse -msse2" ""
  '';
  qtWrapperArgs = prev.qtWrapperArgs ++ [
    "--append-flags" "--platform"
    "--append-flags" "wayland"
  ];
}))

