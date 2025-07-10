{lib, ...}: {
  imports = lib.custom.scanPath {path = ./.;};

  home = {
    homeDirectory = "/Users/${lib.custom.global.username}";
  };
}
