{ config, nixosProfiles, ... }:
{
  imports = with nixosProfiles; [
    system.common.bare
    system.disko.luks-btrfs

    system.nix
    system.sops-nix
    services.logrotate

    networking.iwd
    services.resolved
    services.enthalpy

    hardware.keyboard-mappings
    security.hardware-keys
    security.sudo
    security.polkit
    services.pipewire
    services.greetd

    system.home-manager
    users.allenzch
  ];

  nix.settings.trusted-users = [ "@wheel" ];

  systemd.network = {
    enable = true;
    wait-online.enable = false;
  };

  services.proxy = {
    enable = true;
    inbounds = [
      {
        netnsPath = config.networking.netns.enthalpy.netnsPath;
        listenPort = config.networking.netns.enthalpy.ports.proxy-init-netns;
      }
    ];
  };

  systemd.services.nix-daemon = config.networking.netns.enthalpy.config;

  systemd.services."user@${toString config.users.users.allenzch.uid}" =
    config.networking.netns.enthalpy.config
    // {
      overrideStrategy = "asDropin";
      restartIfChanged = false;
    };

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
  };

  security.pam.services.swaylock = { };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    dconf.enable = true;
    fish.enable = true;
  };
}
