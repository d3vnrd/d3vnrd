{ config, lib, pkgs, ... }: let
  cfg = config.programs.fzf;
in {
  config = lib.mkIf cfg.enable {
    programs.fzf.enableZshIntegration = true;
  };
}
