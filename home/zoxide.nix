{
  config,
  lib,
  ...
}: let
  cfg = config.programs.zoxide;
in {
  config = lib.mkIf cfg.enable {
    programs.zoxide.options = [
      # ...
    ];

    programs.zoxide.enableZshIntegration = true;
  };
}
