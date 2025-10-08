{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
with lib; {
  imports = [./packages];

  config = mergeAttrsList [
    {
      nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
      nixpkgs.config.allowUnfree = mkDefault true;
      users.defaultUserShell = mkIf config.programs.zsh.enable pkgs.zsh;

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };
    }

    (
      if (builtins.isAttrs vars)
      then {
        users.users = {
          ${vars.username} = {
            isNormalUser = mkForce true;
            extraGroups = mkDefault ["wheel"];
          };
        };

        time.timeZone = mkDefault vars.timeZone;
        system.stateVersion = mkForce vars.stateVersion;
      }
      else {
        users.users = {
          nixos = {
            isNormalUser = mkForce true;
            extraGroups = mkDefault ["wheel"];
          };
        };

        time.timeZone = mkDefault "UTC";
        system.stateVersion = mkForce "25.05";
      }
    )
  ];
}
