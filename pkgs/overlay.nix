self: super: {
  canokey-udev-rules = super.callPackage ./canokey-udev-rules { };
  netns-proxy = super.callPackage ./netns-proxy { };
  texmacs-mod = self.callPackage ./texmacs-mod { };
  systemd-run-app = super.callPackage ./systemd-run-app { };
}
