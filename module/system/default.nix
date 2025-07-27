{
  lib,
  var,
  ...
}:
with lib; {
  imports = lib.custom.scanPath {path = ./.;};

  options.M = {
    system = mkOption {
      type = types.enum ["linux" "darwin"];
      default = "linux";
      description = "System type to enable supported modules.";
    };

    state = mkOption {
      type = types.enum ["featured" "minimal"];
      default = "minimal";
      description = "Defined installation option for system.";
    };

    addPkgs = mkOption {
      type = with types; listOf package;
      default = [];
      description = "Additional packages.";
    };

    defaultPkgs = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable default predefined packages";
    };

    displayServer = mkOption {
      type = types.enum ["wayland" "xserver" "none"];
      default = "xserver";
      description = "Display server protocol choices.";
    };
  };

  config = mkMerge [
    mkIf
    (config.M.system == "linux")
    {
    }

    {
      # -- Misc --
      nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
      nixpkgs.config.allowUnfree = mkDefault true;
      time.timeZone = mkDefault var.timeZone;

      # -- Precaution --
      system.stateVersion = mkForce var.stateVersion;
    }
  ];
}
