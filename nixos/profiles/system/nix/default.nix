{ config, ... }: {
  nix = {
    enable = true;
    channel.enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;
      use-cgroups = true;
      flake-registry = "/etc/nix/registry.json";
    };
    registry.p.to = {
      type = "path";
      path = config.nixpkgs.flake.source;
    };
  };
}
