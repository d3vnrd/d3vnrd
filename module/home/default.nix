{
  # inputs,
  lib,
  ...
}:
with lib; {
  imports = custom.scanPath {path = ./.;};

  home = {
    username = "tlmp59";
    file = {};
    sessionVariables = {};
    stateVersion = "25.05";
  };

  home.activation.checkExisting = lib.hm.dag.entryAfter ["linkGeneration"] ''
    git status
  '';
}
