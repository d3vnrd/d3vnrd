{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = custom.scanPath {path = ./.;};

  config = mkIf config.M.isNixos {
    environment.systemPackages = with pkgs; [];
  };
}
