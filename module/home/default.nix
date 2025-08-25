{
  inputs,
  lib,
  ...
}:
with lib; {
  imports = custom.scanPath {path = ./.;};

  config.home = {
    username = "tlmp59";
    file = {};
    sessionVariables = {};
    stateVersion = "25.05";
  };
}
