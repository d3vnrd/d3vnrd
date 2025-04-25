{ config, lib, pkgs, ... }: let
  cfg = config.programs.alacritty;
  configPath = "${config.xdg.configHome}/nix/home/alacritty/config";
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  config = lib.mkIf cfg.enable {
    xdg.configFile."alacritty".source = mkOutOfStoreSymlink configPath
  };
}
