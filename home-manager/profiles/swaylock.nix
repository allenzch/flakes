{ ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {
      show-failed-attempts = true;
      daemonize = true;
      color = "000000";
    };
  };
}
