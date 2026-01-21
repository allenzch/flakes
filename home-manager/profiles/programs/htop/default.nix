{ ... }:
{
  programs.htop.enable = true;

  persistence.directories = [ ".config/htop" ];
}
