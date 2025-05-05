{ config, ... }: {
  nix = {
    enable = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;
      use-cgroups = true;
      flake-registry = "";
    };
    registry.p.to = {
      type = "path";
      path = config.nixpkgs.flake.source;
    };
  };
}
