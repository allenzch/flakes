{ lib, ... }: 
let
  inherit (lib.options) mkOption;
  inherit (lib.types) listOf str;
in {
  options.persistence = {
    files = mkOption {
      type = listOf str;
      default = [ ];
    };
    directories = mkOption {
      type = listOf str;
      default = [ ];
    };
  };
}
