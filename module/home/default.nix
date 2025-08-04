{
  lib,
  var, # global variables retrieved from sops-secret
  ...
}:
with lib; {
  imports = custom.scanPath {path = ./.;};

  # --Other options must be defined within config attr--
  home = {
    inherit (var) username stateVersion;
    file = {};
    sessionVariables = {};
  };
}
#WARN: home-manager was meant to built to use anywhere on any machines not
#system based.

