{ lib }: rec {
  dirsIn = dir: builtins.attrNames ( lib.filterAttrs 
    (_: type: type == "directory")
    (builtins.readDir dir)
  );

  scanPath = path: map (f: (path + "/${f}")) (
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

  getSystems = dirsIn (relativeToRoot "host/");

  forSystems = func: (lib.genAttrs getSystems func);
}

