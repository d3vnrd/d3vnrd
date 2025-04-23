{ config, lib, pkgs, ... }: let
  cfg = config.programs.alacritty;
  configFolder = "${config.xdg.configHome}/nix/home/alacritty";
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "alacritty/alacritty.toml".source = mkOutOfStoreSymlink "${configFolder}/alacritty.toml";
      "alacritty/tokyo_night.toml".source = mkOutOfStoreSymlink "${configFolder}/tokyo_night.toml";
    };
  };
}
