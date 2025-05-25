{
  config,
  lib,
  ...
}: let
  cfg = config.programs.starship;
in {
  config = lib.mkIf cfg.enable {
    programs.starship.settings = {
      add_newline = true;
      scan_timeout = 10;
    };

    programs.starship.enableZshIntegration = true;
  };
}
