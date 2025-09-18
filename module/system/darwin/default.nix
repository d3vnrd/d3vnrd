{
  config,
  lib,
  pkgs,
  helper,
  ...
}:
with lib; {
  options.M.isDarwin = mkEnableOption "Enable modules for darwin system.";

  imports = helper.scanPath {path = ./.;};

  config = mkIf config.M.isDarwin {
    environment.systemPackages = with pkgs; [];
  };
}
