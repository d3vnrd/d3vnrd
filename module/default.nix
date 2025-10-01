lib:
with lib; {
  fromRoot = p: path.append ../. p;

  scanPath = {
    path,
    full ? true,
    filter ? "all",
    exclude ? [],
  }: let
    filteredByType = filterAttrs (
      name: type:
        if filter == "file"
        then
          # Files only: .nix files but not default.nix
          (type == "regular")
          && (name != "default.nix")
          && (hasSuffix ".nix" name)
        else if filter == "dir"
        then
          # Directories only
          type == "directory"
        else if filter == "all"
        then
          # All: directories + .nix files (excluding default.nix)
          (type == "directory")
          || (
            (name != "default.nix")
            && (hasSuffix ".nix" name)
          )
        else throw "scanPath: invalid filter option '${filter}'. Expected one of: file, dir, all."
    ) (builtins.readDir path);

    filteredByExclude = filterAttrs (name: _: !(builtins.elem name exclude)) filteredByType;

    names = builtins.attrNames filteredByExclude;
  in
    if full
    then map (f: (path + "/${f}")) names
    else names;

  #TODO: a better way for notifying error?
  mergeNoOverride = attrsList:
    zipAttrsWith (
      name: values:
        assert assertMsg (length values == 1)
        "'${name}' appears ${toString (length values)} times in config.";
          head values
    )
    attrsList;

  checkFunc = {
    pre-commit-hooks,
    system,
    ...
  }: {
    pre-commit-check = pre-commit-hooks.lib.${system}.run {
      src = ../.;
      hooks = {
        alejandra.enable = true;
      };
    };
  };
}
