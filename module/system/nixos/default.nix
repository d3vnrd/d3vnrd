{
  lib,
  pkgs,
  helper,
  ...
}:
with lib; {
  options.M = {
    displayServer = mkOption {
      type = types.enum ["wayland" "xserver" "none"];
      default = "none";
      description = "Enable choosen display server protocal configurations.";
    };
  };

  imports = helper.scanPath {path = ./.;};

  config = mkMerge [
    {
      #@ Packages for nixos systems only
      environment.systemPackages = with pkgs; [];
    }
  ];
}
