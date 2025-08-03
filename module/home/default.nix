{
  lib,
  var, # global variables retrieved from sops-secret
  ...
}:
with lib; {
  imports = mergeAttrsList [
    (custom.scanPath {exclude = ["nixos" "darwin"];})

    # -- Import system based modules on demand --
    import
    (
      if cfg.system == "linux"
      then ./nixos
      else ./darwin
    )
  ];

  # --Defined options for module configuration within host/<type>/<name>/home.nix
  options.M = {
    system = mkOption {
      type = types.enum ["linux" "darwin"];
      default = "linux";
      description = "System type to enable supported modules.";
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
