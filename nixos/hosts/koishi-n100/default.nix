{ pkgs, nixosProfiles, ... }: {
  imports = (
    [
      ./system.nix
      ./networking.nix
    ] ++
    (with nixosProfiles; [
      users.root
      services.openssh
      services.godns
    ])
  );

  users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrBKIBvt+ktGk0wfGC6dXB3AhH/kq7lgrCNNV7l5fWj"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNDUqt2SdN4i2lt5HiAOfIDxZSCgRcatL5OdXaEM2Xk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDfKG/KKgC6IaK4uu9zn+0wbF4XXK1pcCP/S37u6OAmJ"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDHK6V7pieTigHhvorso7yN3Gy2wu8jYY/qLD+3yh1PLAAAABHNzaDo=
"
  ];


  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
  ];

  networking.netns.enthalpy.forwardPorts = [
    {
      protocol = "tcp";
      netnsPath = "/proc/1/ns/net";
      source = "[::]:22";
      target = "[::]:22";
    }
  ];

  services.godns-multi = {
    ipv6.settings = {
      domains = [
        {
          domain_name = "allenzch.me";
          sub_domains = [ "koishi-n100.dyn" ];
        }
      ];
      ip_type = "IPv6";
      ipv6_urls = [
        "https://ipv6.icanhazip.com"
      ];
    };
  };
}
