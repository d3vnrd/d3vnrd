{
  inputs,
  lib,
  ...
}:
with lib; {
  imports = custom.scanPath {path = ./.;};

  # --Other options must be defined within config attr--
  home = {
    username = "tlmp59";
    file = {};
    sessionVariables = {};
    stateVersion = "25.05";
  };
}
#WARN: home-manager was meant to built to use anywhere on any machines not
#system based.

