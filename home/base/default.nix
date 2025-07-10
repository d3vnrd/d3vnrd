{lib, ...}: {
  imports = lib.custom.scanPath {path = ./.;};

  config.home = {
    inherit (lib.custom.global) username stateVersion;
    file = {};
    sessionVariables = {};
  };
}
