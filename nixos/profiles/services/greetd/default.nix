{ pkgs, lib, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${lib.getExe pkgs.tuigreet} --cmd wayland-session";
    };
  };
}
