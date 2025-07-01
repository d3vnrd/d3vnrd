{mylib, ...}: {
  imports = mylib.scanPath {path = ./.;};

  home = {
    homeDirectory = "/Users/${mylib.global.username}";
  };
}
