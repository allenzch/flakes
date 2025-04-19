{ pkgs, modulesPath, inputs, nixosProfiles, ... }: {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./disko.nix
      ./hardware-configuration.nix
      ./networking.nix
    ] ++
    (with nixosProfiles; [
      services.openssh
      system.common
      users.root
    ]);

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      flake-registry = "";
    };
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };
  };

  security = {
    polkit.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/logrotate.status"
    ];
  };
}
