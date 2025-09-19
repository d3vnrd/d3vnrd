{
  lib,
  pkgs,
  helper,
  ...
}:
with lib; {
  options.M = {
    #@TODO: "none" option should indicate that the current host is a server
    displayServer = mkOption {
      type = types.enum ["wayland" "xserver" "none"];
      default = "none";
      description = "Enable choosen display server protocal configurations.";
    };
  };

  imports = helper.scanPath {path = ./.;};

  config = {
    environment.systemPackages = with pkgs; [];
  };
}
