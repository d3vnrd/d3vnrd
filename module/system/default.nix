{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
with lib; {
  imports = [./packages];

  config = {
    nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
    nixpkgs.config.allowUnfree = mkDefault true;

    users = {
      defaultUserShell =
        mkIf config.programs.zsh.enable pkgs.zsh;

      users.${vars.username} = {
        isNormalUser = mkForce true;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = [];
      };
    };

    time.timeZone = mkDefault vars.timeZone;
    system.stateVersion = mkForce vars.stateVersion;
  };
}
