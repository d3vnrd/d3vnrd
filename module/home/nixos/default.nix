{
  lib,
  var,
  ...
}: {
  imports = lib.custom.scanPath {path=./.;};

  home = {
    homeDirectory = "/home/${var.username}";
  };
}
