{ config, self, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 22 2222 ];
    openFirewall = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
    hostKeys = [
      {
        inherit (config.sops.secrets."ssh_host_ed25519_key") path;
        type = "ed25519";
      }
    ];
  };

  sops.secrets."ssh_host_ed25519_key".sopsFile = "${self}/secrets/hosts/${config.networking.hostName}.yaml";
}
