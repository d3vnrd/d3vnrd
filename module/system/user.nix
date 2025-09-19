{
  config,
  lib,
  pkgs,
  ...
}: let
in
  with lib; {
    users.users.root = {
      # initialHashedPassword = "";
    };

    users.users."tlmp59" = {
      description = "Default master user for all host machines.";
      # initialHashedPassword = "";
      isNormalUser = mkForce true;
      extraGroups = mkDefault ["wheel"];
      openssh.authorizedKeys.keys = {};
    };

    users.defaultUserShell = mkIf config.programs.zsh.enable pkgs.zsh;
  }
