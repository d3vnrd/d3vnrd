{ config, lib, pkgs, ... }: let
  cfg = config.programs.zell;
in {
  config = lib.mkIf cfg.enable {
    programs.zellij.settings = {};
    programs.zellij.enableZshIntegration = true;
  };
}
