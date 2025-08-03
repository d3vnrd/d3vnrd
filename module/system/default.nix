{
  config,
  lib,
  var,
  ...
}: let
  cfg = config.M;
in
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

    # -- Custom option to config system --
    options.M = {
      clean = mkEnableOption "Install system with a clean state.";

      system = mkOption {
        type = types.enum ["linux" "darwin"];
        default = "linux";
        description = "System type to enable supported modules.";
      };

      state = mkOption {
        type = types.enum ["featured" "minimal" "non-boot"];
        default = "non-boot";
      };

      displayServer = mkOption {
        type = types.enum ["wayland" "xserver" "none"];
        default = "xserver";
        description = "Display server protocol choices.";
      };
    };

    # -- Misc --
    nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
    nixpkgs.config.allowUnfree = mkDefault true;
    time.timeZone = mkDefault var.timeZone;

    # -- Precaution --
    system.stateVersion = mkForce var.stateVersion;
  }
