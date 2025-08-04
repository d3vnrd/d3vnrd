{
  lib,
  var, # global variables retrieved from sops-secret
  ...
}:
with lib; {
  imports = custom.scanPath {path = ./.;};

  # --Defined options for module configuration within host/<type>/<name>/home.nix
  options.M = {
    system = mkOption {
      type = types.enum ["linux" "darwin"];
      default = "linux";
      description = "System type to enable supported modules.";
    };
  };

  # --Other options must be defined within config attr--
  config = {
    home = {
      inherit (var) username stateVersion;
      file = {};
      sessionVariables = {};
    };
  };
}
