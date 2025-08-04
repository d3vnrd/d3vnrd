{
  config,
  lib,
  var,
  ...
}:
with lib; {
  imports =
    mkIf (config.M.system != "darwin")
    custom.scanPath {path = ./.;};

  config = {
    home = {
      homeDirectory = "/home/${var.username}";
    };
  };
}
