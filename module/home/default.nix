{
  lib,
  var, # global variables retrieved from sops-secret
  ...
}:
with lib; {
  imports = lib.custom.scanPath {path = ./.;};

  # --Defined options for module configuration within host/<type>/<name>/home.nix
  options.M = {
    system = mkOption {
      type = types.enum ["linux" "darwin"];
      default = "linux";
      description = "System type to enable supported modules.";
    };

    state = mkOption {
      type = types.enum ["featured" "minimal"];
      default = "minimal";
      description = "Defined installation option for user home.";
    };

    addPkgs = mkOption {
      type = with types; listOf package;
      default = [];
      description = "Additional home packages.";
    };

    defaultPkgs = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable default predefined home packages";
    };

    editor = mkOption {
      type = types.enum ["nvim" "nvim_vscode"];
      default = "nvim";
      description = "Editor options.";
    };

    shell = mkOption {
      type = types.enum ["zsh" "bash"];
      defautl = "zsh";
      description = "Shell choice for programs support.";
    };
  };

  config = {
    home = {
      inherit (var) username stateVersion;
      file = {};
      sessionVariables = {};
    };
  };
}
