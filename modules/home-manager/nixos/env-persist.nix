{ lib, ... }: 
with lib;
{
  options.envPersist = {
    files = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    directories = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };
}
