{ pkgs }: {
  systemd-run-app = pkgs.callPackage ./systemd-run-app { };
  texmacs = pkgs.callPackage ./texmacs { };
  canokey-udev-rules = pkgs.callPackage ./canokey-udev-rules { };
}
