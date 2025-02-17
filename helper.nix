{
  loadModules = dir: 
    let
      isNix = name: builtins.match ".*\\.nix$" name != null;
      isValid = file:
        let module = import (dir + "/" + file);
        in builtins.isAttrs module && builtins.hasAttr "config" module;
    in
     map (file: import (dir + "/" + file))
       (
         builtins.filter (file: isNix file && isValid file)
           (builtins.attrNames (builtins.readDir dir))
       );
}
