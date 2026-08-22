{
  pkgs,
  self,
  nixosProfiles,
  ...
}:
{
  imports = [ ./system.nix ] ++ (
    with nixosProfiles; [
      users.root
      services.openssh
      services.resolved
    ]
  );

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrBKIBvt+ktGk0wfGC6dXB3AhH/kq7lgrCNNV7l5fWj"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNDUqt2SdN4i2lt5HiAOfIDxZSCgRcatL5OdXaEM2Xk"
  ];

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
  ];

  sops.secrets."user-password/root".sopsFile = "${self}/secrets/hosts/chiyuri-1197.yaml";

  systemd.network = {
    enable = true;
    networks."20-eno1" = {
      matchConfig.Name = "eno1";
      address = [ "10.13.34.31/24" ];
      gateway = [ "10.13.34.1" ];
      dns = [ "10.10.0.21" ];
    };
  };
}
