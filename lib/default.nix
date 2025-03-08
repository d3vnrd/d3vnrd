{ lib }: {
  dirsIn = dir: builtins.attrNames ( lib.filterAttrs 
    (_: type: type == "directory")
    (builtins.readDir dir)
  );

  filesIn = dir: builtins.attrNames ( lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".nix" name)
    (builtins.readDir dir)
  );

  scanPaths = path: map (f: (path + "/${f}")) (
    builtins.attrNames (
      lib.filterAttrs (path: type:
	(type == "directory") # include directories
	|| (
	  (path != "default.nix") # ignore default.nix
	  && (lib.hasSuffix ".nix" path) # include .nix file
	)
      ) (builtins.readDir path)
    ) 
  );
 
  relativeToRoot = lib.path.append ../.;

  loadModules = dir: 
    let
      isNix = file: lib.hasSuffix "..nix" file;
      isValid = file:
        let module = import (dir + "/${file}");
        in builtins.isAttrs module && builtins.hasAttr "config" module;
    in map (file: import (dir + file)) (builtins.filter 
      (file: isNix file && isValid file) 
      (builtins.attrNames (builtins.readDir dir))
    );
}
