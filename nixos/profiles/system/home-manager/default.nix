{ mylib, inputs, data, homeProfiles, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = {
      inherit mylib inputs data homeProfiles;
    };
  };
}
