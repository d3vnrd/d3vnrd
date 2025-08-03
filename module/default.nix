lib: {
  #TODO: write other pre-commit-check hooks
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

  relativeToRoot = lib.path.append ../.;

  #TODO: add parameter type checking
  scanPath = {
    path,
    full ? true,
    filter ? "all",
  }: let
    names = builtins.attrNames (
      lib.filterAttrs (
        name: type:
            if filter == "file"
            then
              # Files only: .nix files but not default.nix
              (type == "regular")
              && (name != "default.nix")
              && (lib.hasSuffix ".nix" name)
            else if filter == "dir"
            then
              # Directories only
              type == "directory"
            else
              # All: directories + .nix files (excluding default.nix)
              (type == "directory")
              || (
                (name != "default.nix")
                && (lib.hasSuffix ".nix" name)
              )
      ) (builtins.readDir path)
    );
  in
    if full
    then map (f: (path + "/${f}")) names
    else names;
}
