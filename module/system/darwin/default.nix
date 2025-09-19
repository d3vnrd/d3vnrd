{
  config,
  lib,
  pkgs,
  helper,
  ...
}:
with lib; {
  imports = helper.scanPath {path = ./.;};

  options.M = {};

  config = {
    environment.systemPackages = with pkgs; [];
  };
}
