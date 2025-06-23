{lib}: {
  info = {
    user = "tlmp59";
    shell = "zsh";
    version = "24.11";
  };

  networking = {};

  dirsIn = dir:
    builtins.attrNames (
      lib.filterAttrs
      (_: type: type == "directory")
      (builtins.readDir dir)
    );

  scanPath = path:
    map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.filterAttrs (
          path: type:
            (type == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (lib.hasSuffix ".nix" path) # include `.nix` file
            )
        ) (builtins.readDir path)
      )
    );

  relativeToRoot = lib.path.append ../.;
}
