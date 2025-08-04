{
  lib,
  var,
  ...
}:
with lib; {
  # -- Custom option to config system --
  options.M = {
    isNixos = mkEnableOption "Enable support for Nixos systems";
    isDarwin = mkEnableOption "Enable supports for Mac-like systems.";

    displayServer = mkOption {
      type = types.enum ["wayland" "xserver" "none"];
      default = "wayland";
      description = "Display server protocol choices.";
    };
  };

  # --Import other important modules
  imports = custom.scanPath {path = ./.;};

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
