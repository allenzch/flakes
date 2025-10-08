{ nixosProfiles, ... }: {
  imports = (
    [ ./system.nix ] ++ 
    (with nixosProfiles; [ services.openssh ])
  );

  users.users.allenzch.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNDUqt2SdN4i2lt5HiAOfIDxZSCgRcatL5OdXaEM2Xk"
  ];

  networking.netns.enthalpy.forwardPorts = [
    {
      protocol = "tcp";
      netnsPath = "/proc/1/ns/net";
      source = "[::]:22";
      target = "[::]:22";
    }
  ];
}
