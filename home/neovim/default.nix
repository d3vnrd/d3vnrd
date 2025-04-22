{ config, lib, pkgs, ... }: let
  configPath = "${config.home.homeDirectory}/.config/nix/home/neovim/config";
  cfg = config.programs.neovim;
in {
  config = lib.mkIf cfg.enable {
    # xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configPath;

    programs.neovim = {
      viAlias = true;
      vimAlias = true;
    };

    programs.neovim.extraLuaConfig = ''
      vim.opt.termguicolors = true
    '';
  };
}
