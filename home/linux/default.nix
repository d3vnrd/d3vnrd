{lib, ...}: {
  imports = lib.custom.scanPath {path = ./.;};

  home = {
    homeDirectory = "/home/${lib.custom.global.username}";
  };
}
