{
  config,
  lib,
  pkgs,
  helper,
  ...
}:
with lib; {
  options.M = {
    isDesktop = mkEnableOption "Enable modules for a complete featured desktop.";

    # -- Custom option to configuring system --
    displayServer = mkOption {
      type = types.enum ["wayland" "xserver" "none"];
      default = "wayland";
      description = "User options for display server protocol.";
    };
  };

  imports = helper.scanPath {path = ./.;};

  config = mkIf (!config.M.isDarwin) {
    environment.systemPackages = with pkgs; [];
  };
}
