{
  lib,
  var,
  pkgs,
  ...
}:
with lib; {
  users.users.root = {};

  users.users."${var.username}" = {
    isNormalUser = mkForce true;
    extraGroups = mkDefault ["wheel"];
    description = "Default user for all host machines.";
  };

  users.defaultUserShell = pkgs.zsh;
}
