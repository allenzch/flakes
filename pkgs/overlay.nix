self: super: {
  canokey-udev-rules = super.callPackage ./canokey-udev-rules { };
  netns-proxy = super.callPackage ./netns-proxy { };
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (pyfinal: pyprev: {
      simple-websocket-server = pyfinal.callPackage ./simple-websocket-server { };
    })
  ];
  systemd-run-app = super.callPackage ./systemd-run-app { };
  vimPlugins = super.vimPlugins // {
    nvim-ghost-nvim = super.callPackage ./nvim-ghost-nvim { };
  };
  xkeyboard_config-mod = super.callPackage ./xkeyboard_config-mod { };
}
