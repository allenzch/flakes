{
  description = "a nix flake for system deployment";

  outputs = { self, nixpkgs, disko, impermanence, sops-nix, home-manager, ... } @ inputs:
    let
      mylib = import ./lib {
        inherit inputs;
        inherit (nixpkgs) lib;
      };
      data = import ./data.nix;
    in
    {
      inherit mylib;
      nixosModules = mylib.buildModuleList ./nixos/modules;
      nixosProfiles = mylib.rakeLeaves ./nixos/profiles;
      homeModules = mylib.buildModuleList ./home-manager/modules;
      homeProfiles = mylib.rakeLeaves ./home-manager/profiles;
      nixosConfigurations = {
        sakura-wj14 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            ./hosts/sakura-wj14/nixos.nix
          ] ++ self.nixosModules;
          specialArgs = inputs // {
            inherit mylib;
            inherit (self) nixosProfiles;
            inherit (self) homeModules;
            inherit (self) homeProfiles;
            inherit data;
            inherit inputs;
          };
        };
        koishi-n100 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            ./hosts/koishi-n100/nixos.nix
          ] ++ self.nixosModules;
          specialArgs = inputs // {
            inherit mylib inputs;
            inherit (self) nixosProfiles;
          };
        };
        misaka-b760 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            ./hosts/misaka-b760/nixos.nix
          ] ++ self.nixosModules;
          specialArgs = inputs // {
            inherit mylib;
            inherit (self) nixosProfiles;
            inherit (self) homeModules;
            inherit (self) homeProfiles;
            inherit data;
            inherit inputs;
          };
        };
      };
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
  };
}
