{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.M.isDarwin = mkEnableOption "Enable modules for darwin system.";

  imports = custom.scanPath {path = ./.;};

  config = mkIf config.M.isDarwin {
    environment.systemPackages = with pkgs; [];
  };
}
