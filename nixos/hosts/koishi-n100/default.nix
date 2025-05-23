{ pkgs, nixosProfiles, ... }: {
  imports = (
    [
      ./system.nix
      ./networking.nix
    ] ++
    (with nixosProfiles; [
      users.root
      services.openssh
    ])
  );

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
}
