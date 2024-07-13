{ pkgs }: {
  systemd-run-app = pkgs.callPackage (import ./systemd-run-app) { };
}
