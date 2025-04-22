{ config, lib, pkgs, ... }: let
  configPath = "${config.home.homeDirectory}/.config/nix/home/neovim/config";
  cfg = config.programs.neovim;
in {
  config = lib.mkIf cfg.enable {
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configPath;

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
