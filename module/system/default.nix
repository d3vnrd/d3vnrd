{
  config,
  lib,
  pkgs,
  helper,
  vars,
  ...
}:
with lib; {
  options.M.hostState = mkOption {
    type = types.enum ["init" "server" "desktop"];
    default = "init";
    description = ''
      Define installing options for current host.
      - init: Only contains essential configs for remote install nixos
      - server: Server side configs, no gui application support
      - desktop: Featured rich configs for a complete experience

      Tips: install nixos with "init" options then change accordingly to needs
    '';
  };

  imports = helper.scanPath {
    path = ./.;
    exclude = ["nixos" "darwin"];
  };

  config = {
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
  };
}
