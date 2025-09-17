{lib, ...}:
with lib; {
  # --Import other important modules
  imports = custom.scanPath {path = ./.;};

  # -- Unified system info --
  config = {
    # -- Misc --
    nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
    nixpkgs.config.allowUnfree = mkDefault true;
    time.timeZone = mkDefault "Asia/Vietnam";

    # -- Precaution --
    system.stateVersion = mkForce "25.05";
  };
}
