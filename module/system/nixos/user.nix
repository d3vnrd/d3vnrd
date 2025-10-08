{
  config,
  lib,
  vars,
  ...
}:
with lib; {
  options.M.user = {
    type = mkOption {
      type = types.enum ["default" "bootstrap"];
      default = "default";
      description = "Type of user for specific cases";
    };

    loginSSHs = mkOption {
      type = with types; listOf strings;
      default = [];
      description = "List of authorized SSH keys for server login.";
    };
  };

  config = mkMerge [
    (mkIf (config.M.user == "default") {
      users.users.${vars.username} = {
      };
    })

    (mkIf (config.M.user == "bootstrap") {
      users.users."nixos" = {};
    })
  ];
}
