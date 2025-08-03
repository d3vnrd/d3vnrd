{
  config,
  lib,
  var,
  ...
}: let
  cfg = config.M;
in
  with lib; {
    imports = custom.scanPath {path = ./.;};

    # -- Custom option to config system --
    options.M = {
      clean = mkEnableOption "Install system with a clean state.";

      system = mkOption {
        type = types.enum ["linux" "darwin"];
        default = "linux";
        description = "System type to enable supported modules.";
      };

      displayServer = mkOption {
        type = types.enum ["wayland" "xserver" "none"];
        default = "xserver";
        description = "Display server protocol choices.";
      };
    };
    
    # -- Unified system info --
    config = {
	    # -- Misc --
	    nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
	    nixpkgs.config.allowUnfree = mkDefault true;
	    time.timeZone = mkDefault var.timeZone;

	    # -- Precaution --
	    system.stateVersion = mkForce var.stateVersion;
    };
  }
