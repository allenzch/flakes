{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.enthalpy.overlays.default
  ];
}
