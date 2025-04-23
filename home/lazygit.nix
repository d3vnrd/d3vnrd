{ config, lib, pkgs, ... }: let
  cfg = config.programs.lazygit;
in {
  config = lib.mkIf cfg.enable {
    programs.lazygit.settings = {
      # ...
    };
  };
}
