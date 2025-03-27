{ lib, ... }:
let
  serviceHardened = import ./service-hardened.nix { inherit lib; };
in
{
  inherit serviceHardened;
}
