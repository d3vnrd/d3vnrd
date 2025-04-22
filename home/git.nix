{ config, lib, pkgs, ... }: let
  cfg = config.programs.git;
in {
  config = lib.mkIf cfg.enable {
    programs.git = {
      userEmail = "yurii@goxore.com";
      userName = "yurii";
    };
  };
}
