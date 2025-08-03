{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.M.isNixos = mkEnableOption "Enable support for Nixos systems";

  imports = mkIf (config.M.isNixos) (custom.scanPath {path=./.;});

  config = config.M.isNixos {
	  environment.systemPackages = with pkgs; [];
  };
}
