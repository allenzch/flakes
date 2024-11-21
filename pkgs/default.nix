{ pkgs }: {
  systemd-run-app = pkgs.callPackage ./systemd-run-app { };
  texmacs = pkgs.callPackage ./texmacs { };
}
