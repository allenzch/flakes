{ ... }:
{
  programs.zoxide.enable = true;

  persistence.directories = [
    ".local/share/zoxide"
  ];
}
