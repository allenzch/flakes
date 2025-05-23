{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "canokey-udev-rules";
  version = "unstable-2025-02-22";

  src = ./69-canokey.rules;
  dontUnpack = true;

  installPhase = ''
    install -D -m444 $src $out/lib/udev/rules.d/69-canokey.rules
  '';

  meta = {
    description = "udev rules for CanoKey";
    homepage = "https://docs.canokeys.org/userguide/setup";
  };
}
