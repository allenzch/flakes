{
  security.sudo.enable = true;
  environment.persistence."/persist" = {
    directories = [ "/var/db/sudo" ];
  };
}
