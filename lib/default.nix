{ lib, inputs, rebmit, ... }: rec {
  haumea = inputs.haumea.lib;

  rakeLeaves =
    src:
    haumea.load {
      inherit src;
      loader = haumea.loaders.path;
      transformer =
        _cursor: dir:
        if dir ? default then
          dir.default
        else
          dir;
    };

  flattenTree =
    tree:
    let
      mkNewPrefix = prefix: name: "${if prefix == "" then "" else "${prefix}/"}${name}";
      flattenTree' =
        prefix: remain:
        if lib.isAttrs remain then
          lib.flatten (lib.mapAttrsToList (name: value: flattenTree' (mkNewPrefix prefix name) value) remain)
        else
          [ (lib.nameValuePair prefix remain) ];
    in
    lib.listToAttrs (flattenTree' "" tree);

  buildModuleList = dir: lib.attrValues (flattenTree (rakeLeaves dir));

  getItemNames = path: keep:
    let
      inherit (lib) types;
      pred =
        if keep == null
        then (_: _: true)
        else if types.singleLineStr.check keep
        then (name: _: !(name == keep))
        else if lib.isFunction keep
        then keep
        else if (types.listOf types.singleLineStr).check keep
        then (name: _: !(builtins.elem name keep))
        else throw "importDir predicate should be a string, function, or list of strings";
      isNix = name: type:
        (type == "regular" && lib.hasSuffix ".nix" name)
        || (lib.pathIsRegularFile "${path}/${name}/default.nix");
      pred' = name: type: (isNix name type) && (pred name type);
    in
    with builtins; (
      attrNames
        (lib.filterAttrs pred' (readDir path))
    );

  getItemPaths = path: keep: (
    map
      (name: path + "/${name}")
      (getItemNames path keep)
  );

  inherit (rebmit.lib) network misc;
}
