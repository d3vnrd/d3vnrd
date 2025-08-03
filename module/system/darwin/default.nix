{
config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.M.isDarwin = mkEnableOption "Enable supports for Mac-like systems.";

  imports = mkIf (config.M.isDarwin) (custom.scanPath {path=./.;});

  config = mkIf config.M.isDarwin {
	  environment.systemPackages = with pkgs; [];
  };
}
