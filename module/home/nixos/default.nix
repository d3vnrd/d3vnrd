{
  lib,
  var,
  ...
}: {
  imports = lib.custom.scanPath;

  home = {
    homeDirectory = "/home/${var.username}";
  };
}
