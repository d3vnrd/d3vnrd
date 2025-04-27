{ config, lib, pkgs, ... }: let
  cfg = config.programs.alacritty;
  configPath = "${config.xdg.configHome}/nix/home/alacritty/config";
in {
  config = lib.mkIf cfg.enable {
    xdg.configFile."alacritty".source = config.lib.file.mkOutOfStoreSymlink configPath;
  };
}
