{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = custom.scanPath {path = ./.;};

  environment.systemPackages = with pkgs; [];
}
