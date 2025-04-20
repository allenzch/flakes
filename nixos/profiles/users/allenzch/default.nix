{ config, pkgs, mylib, inputs, data, homeModules, homeProfiles, ... }:
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

  environment.persistence."/persist".users.${name} = {
    inherit (config.home-manager.users.${name}.persistence) files directories;
  };

  home-manager = {
    users.${name} = {
      imports = homeModules ++ [
        homeProfiles.users.${name}
      ];
    };
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = {
      inherit mylib inputs data homeProfiles;
    };
  };
}
