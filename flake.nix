{
  description = "a nix flake for system deployment";

  outputs = { self, nixpkgs, disko, impermanence, sops-nix, home-manager, nixpkgs-stable, ... } @ inputs:
    let
      mylib = import ./lib {
        inherit inputs;
        inherit (nixpkgs) lib;
      };
      mypkgs = import ./pkgs { inherit pkgs; };
      data = import ./data.nix;
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      pkgs-stable = import nixpkgs-stable {
        system = "x86_64-linux";
        config = {
          permittedInsecurePackages = [
            "electron-27.3.11"
          ];
        };
      };
    in
    {
      nixosModules = mylib.buildModuleList ./nixos/modules;
      nixosProfiles = mylib.rakeLeaves ./nixos/profiles;
      hmModules = import ./home-manager/modules;
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
            inherit mypkgs;
            inherit (self) nixosProfiles;
            inherit (self) hmModules;
            inherit (self) homeProfiles;
            inherit data;
            inherit inputs;
            inherit pkgs-stable;
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
            inherit mypkgs;
            inherit (self) nixosProfiles;
            inherit (self) hmModules;
            inherit (self) homeProfiles;
            inherit data;
            inherit inputs;
            inherit pkgs-stable;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
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
    nix-colors.url = "github:misterio77/nix-colors";
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
