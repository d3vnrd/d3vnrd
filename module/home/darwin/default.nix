{
  lib,
  var,
  ...
}: {
  imports = lib.custom.scanPath;

  home = {
    homeDirectory = "/Users/${var.username}";
  };
}
