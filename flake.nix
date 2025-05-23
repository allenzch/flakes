{
  description = "a nix flake for system deployment";

  outputs = { self, ... } @ inputs:
  let
    inherit (inputs.nixpkgs.lib) mergeAttrsList nixosSystem singleton;
    mylib = import ./lib {
      inherit inputs;
      inherit (inputs.nixpkgs) lib;
    };
    data = import ./data.nix;
    nixosModules = mylib.buildModuleList ./nixos/modules;
    nixosProfiles = mylib.rakeLeaves ./nixos/profiles;
    homeModules = mylib.buildModuleList ./home-manager/modules;
    homeProfiles = mylib.rakeLeaves ./home-manager/profiles;
    mkNixosHost =
    {
      name,
      configuration ? ./nixos/hosts/${name},
      extraSpecialArgs ? { }
    }:
    {
      ${name} = nixosSystem {
        modules = (with inputs; [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
        ]) ++ nixosModules ++
        singleton {
          nixpkgs.overlays = [
            inputs.enthalpy.overlays.default
            (import ./pkgs/overlay.nix)
          ];
          networking.hostName = "${name}";
        } ++ singleton configuration;
        specialArgs = {
          inherit self inputs mylib nixosProfiles homeModules homeProfiles;
        } // extraSpecialArgs;
        system = "x86_64-linux";
      };
    };
  in
  {
    inherit mylib nixosModules nixosProfiles homeModules homeProfiles mkNixosHost;
    nixosConfigurations = mergeAttrsList [
      (mkNixosHost {
        name = "sakura-wj14";
        extraSpecialArgs = { inherit data; };
      })
      (mkNixosHost {
        name = "koishi-n100";
      })
      (mkNixosHost {
        name = "misaka-b760";
        extraSpecialArgs = { inherit data; };
      })
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    enthalpy.url = "https://git.rebmit.moe/rebmit/enthalpy/archive/master.tar.gz";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallpapers = {
      url = "git+ssh://git@github.com/allenzch/wallpapers.git?shallow=1";
      flake = false;
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
