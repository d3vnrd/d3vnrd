{
  config,
  lib,
  pkgs,
  helper,
  vars,
  ...
}:
with lib; {
  imports = helper.scanPath {
    path = ./.;
    exclude = ["nixos" "darwin"];
  };

  users.defaultUserShell =
    mkIf config.programs.zsh.enable pkgs.zsh;

  users.users.root = {
    # initialHashedPassword = "";
  };

  users.users.${vars.username} = {
    description = "Default user for all host machines.";
    # initialHashedPassword = "";
    isNormalUser = mkForce true;
    extraGroups = mkDefault ["wheel"];
    openssh.authorizedKeys.keys = [];
  };

  time.timeZone = mkDefault vars.timeZone;
}
