{ config, lib, pkgs, ... }: let
  cfg = config.programs.alacritty;
in {
  options.programs.alacritty = {
    enableWindowIntegration = lid.mkEnableOption "Generate Alacirtty config wihout enable it"
  };

  config = lib.mkIf (cfg.enable) {
    program.alacritty.enable = lib.mkIf cfg.enableWindowIntegration false;

    home.activation.linkWindowPath = lib.mkIf cfg.enableWindowIntegration (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ln -sf "${config.xdg.configFile}/alacritty/alacritty.yml" \
	  "/mnt/c/Users/Tinng/AppData/Roaming/alacritty/alacritty.yml"
      ''
    );

    programs.alacritty.settings = {
      window = {
        decorations = "None";
        startup_mode = "Fullscreen";
      };

      font.normal.family = "JetbrainsMono Nerd Font";

      cursor.style.shape = "Block";
      cursor.style.blinking = "Never";
      cursor.unfocused_hollow = true;

      mouse.hide_when_typing = true;
    };

    programs.alacritty.theme = "tokyo_night"
  };
}
