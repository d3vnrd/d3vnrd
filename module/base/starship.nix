{ config, lib, pkgs, ... }: let
  cfg = config.programs.starship;
in {
  config = lib.mkIf cfg.enable {
    programs.starhip = {
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    programs.starship.settings = {
      character = {
        success_symbol = "[›](bold green)";
	error_symbol = "[›](bold red)";
      };
    };

  };
}
