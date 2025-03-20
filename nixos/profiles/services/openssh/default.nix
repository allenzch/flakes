{ ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 22 2222 ];
    openFirewall = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };
}
