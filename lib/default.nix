lib: {
  global = {
    user = "tlmp59";
    shell = "zsh";
    version = "24.11";
  };

  networking = {};

  relativeToRoot = lib.path.append ../.;

  scanPath = path: {
    full ? true,
    filter ? "all", # "all" | "file" | "dir"
  }: let
    entries = builtins.readDir path;

    # Define filter predicates
    filterPredicate = name: type:
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
          (type == "regular")
          && (name != "default.nix")
          && (lib.hasSuffix ".nix" name)
        );

    # Filter entries
    filteredEntries = lib.filterAttrs filterPredicate entries;

    # Get names
    names = builtins.attrNames filteredEntries;
    # Return full paths or just names
  in
    if full
    then map (name: path + "/${name}") names
    else names;
}
