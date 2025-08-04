{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = custom.scanPath {path = ./.;};

  config = mkIf config.M.isDarwin {
    environment.systemPackages = with pkgs; [];
  };
}
