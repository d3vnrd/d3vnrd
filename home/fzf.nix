{
  config,
  lib,
  ...
}: let
  cfg = config.programs.fzf;
in {
  config = lib.mkIf cfg.enable {
    programs.fzf.enableZshIntegration = true;
  };
}
