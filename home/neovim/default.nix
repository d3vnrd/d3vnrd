{ config, lib, pkgs, ... }: let
  configPath = "${config.home.homeDirectory}/.config/nix/home/neovim/config";
in {
  # --> Create symlink outside of nix/store
  # xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configPath;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}
