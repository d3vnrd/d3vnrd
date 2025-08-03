lib:
with lib; {
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

  relativeToRoot = path.append ../.;

  #TODO: add parameter type checking
  scanPath = {
    path ? ./.,
    full ? true,
    filter ? "all",
    exclude ? [],
  }: let
    names = builtins.attrNames (
      filterAttrs (
        name: type:
          !(builtins.elem name exclude)
          && (
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
            else
              # All: directories + .nix files (excluding default.nix)
              (type == "directory")
              || (
                (name != "default.nix")
                && (hasSuffix ".nix" name)
              )
          )
      ) (builtins.readDir path)
    );
  in
    if full
    then map (f: (path + "/${f}")) names
    else names;
}
