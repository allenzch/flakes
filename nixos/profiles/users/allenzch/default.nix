{ config, pkgs, mylib, mypkgs, inputs, data, homeModules, homeProfiles, ... }:
let
  name = "allenzch";
  uid = 1000;
  homeDirectory = "/home/${name}";
in {
  users.users.${name} = {
    inherit uid;
    hashedPasswordFile = config.sops.secrets."user-password/${name}".path;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    home = homeDirectory;
    shell = pkgs.fish;
  };

  sops.secrets."user-password/${name}" = {
    neededForUsers = true;
    sopsFile = "${inputs.self}/secrets/local.yaml";
  };

  programs.fish.enable = true;

  custom.hm-nixos.${name}.enable = true;
  
  home-manager = {
    users.${name} = {
      imports = [
        inputs.impermanence.nixosModules.home-manager.impermanence
      ] ++ homeModules ++ [
        homeProfiles.users.${name}
      ];
    };
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = {
      inherit mylib mypkgs inputs data homeProfiles;
    };
  };
}
