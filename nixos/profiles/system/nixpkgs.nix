{ self, inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.enthalpy.overlays.default
    (import "${self}/pkgs/overlay.nix")
  ];
}
