{
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; {
  users.users.root = {};

  users.users."tlmp59" = {
    isNormalUser = mkForce true;
    extraGroups = mkDefault ["wheel"];
    description = "Default user for all host machines.";
  };

  users.defaultUserShell = pkgs.zsh;
}
