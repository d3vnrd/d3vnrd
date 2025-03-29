{ lib }: rec {
  dirsIn = dir: builtins.attrNames ( lib.filterAttrs 
    (_: type: type == "directory")
    (builtins.readDir dir)
  );

  filesIn = dir: map lib.strings.removeSuffix ".nix" 
    (builtins.attrNames ( lib.filterAttrs
      (name: type: type == "regular" && lib.hasSuffix ".nix" name)
      (builtins.readDir dir)
    ));

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

  getSystems = dirsIn ../host;

  forSystems = func: (lib.genAttrs getSystems func);
}
