{
  services.logrotate = {
    enable = true;
    extraArgs = [
      "-s"
      "/var/lib/logrotate/status"
    ];
  };

  systemd.services.logrotate.serviceConfig = {
    StateDirectory = "logrotate";
  };

  environment.persistence."/persist".directories = [ "/var/lib/logrotate" ];
}
