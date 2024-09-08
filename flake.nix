{
  description = "a nix flake for system deployment";

  outputs = { self, nixpkgs, disko, impermanence, home-manager, ... } @ inputs:
    let
      mylib = import ./lib { inherit (nixpkgs) lib; };
      mypkgs = import ./pkgs { inherit pkgs; };
      data = import ./data.nix;
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      nixosModules = import ./modules/nixos;
      hmModules = import ./modules/home-manager;
      nixosConfigurations = {
        sakura-wj14 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            self.nixosModules
            ./hosts/sakura-wj14/nixos.nix
          ];
          specialArgs = inputs // {
            inherit mylib;
            inherit mypkgs;
            inherit (self) hmModules;
            inherit data;
          };
        };
        misaka-b760 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            self.nixosModules
            ./hosts/misaka-b760/nixos.nix
          ];
          specialArgs = inputs // {
            inherit mylib;
            inherit mypkgs;
            inherit (self) hmModules;
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
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
