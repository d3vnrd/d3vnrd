{
  lib,
  globalVars,
  ...
}: {
  imports = lib.custom.scanPath {path = ./.;};

 config.home = {
    inherit (globalVars) username;
    inherit (lib.custom.global) stateVersion;
    file = {};
    sessionVariables = {};
  };
}
