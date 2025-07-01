{mylib, ...}: {
  imports = mylib.scanPath {path = ./.;};

  home = {
    homeDirectory = "/home/${mylib.global.username}";
  };
}
