{ config, lib, pkgs, ... }: let
  cfg = config.programs.my_alacritty;
  configFolder = "${config.xdg.configHome}/nix/home/alacritty";
  mkOutOfSymlink = config.lib.file.mkOutOfSymlink;
in {
  options.programs.my_alacritty = {
    enable = lib.mkEnableOption "Custom alacritty options";
    enableWindowIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Create symlink to window alacritty
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "alacritty/alacritty.toml" = mkOutOfSymlink "${configFolder}/alacritty.toml"
      "alacritty/tokyo_night.toml" = mkOutOfSymlink "${configFolder}/tokyo_night.toml"
    };
    
    programs.alacritty.enable = if cfg.windowIntegration = lib.mkOption;

    home.activation.linkWindowPath = lib.mkIf cfg.enableWindowIntegration (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p "/mnt/c/Users/Tinng/AppData/Roaming/alacritty/"
        run cp "${config.xdg.configHome}/alacritty/alacritty.toml" \
	  "/mnt/c/Users/${win_user}/AppData/Roaming/alacritty/"
      ''
    );
  };
}
