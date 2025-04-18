{ config, lib, pkgs, ... }: let
  configFile = "${config.home.homeDirectory}/.config/nix/home/zsh/.zshrc";
in {
  xdg.configFile."zsh/.zshrc".source = config.lib.file.mkOutOfStoreSymlink configFile;

  programs.zsh = {
    enable = true;
  };
}
