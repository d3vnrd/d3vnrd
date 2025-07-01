{mylib, ...}: {
  imports = mylib.scanPath {path = ./.;};

  config.home = {
    inherit (mylib.global) username stateVersion;
    file = {};
    sessionVariables = {};
  };
}
