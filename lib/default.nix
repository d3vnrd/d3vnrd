{ lib }: {
  getDirNames = dir: builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir)
  );

  loadModules = dir: 
    let
      isNix = file: builtins.match ".*\\.nix$" file != null;
      isValid = file:
        let module = import (dir + "/${file}");
        in builtins.isAttrs module && builtins.hasAttr "config" module;
    in map (file: import (dir + file)) (
      builtins.filter (file: isNix file && isValid file) (builtins.attrNames (builtins.readDir dir))
    );
}
