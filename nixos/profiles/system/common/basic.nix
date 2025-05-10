{ nixosProfiles, ... }:
{
  imports = with nixosProfiles; [
    system.common.bare

    system.nix
    system.sops-nix
    services.logrotate
  ];
}
