{ pkgs, mypkgs, ... }:
{
  services.udev.packages = with mypkgs; [ canokey-udev-rules ];

  services.pcscd = {
    enable = true;
    plugins = with pkgs; [ ccid ];
  };
}
