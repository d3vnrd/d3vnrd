{ config, pkgs, lib, ... }:{
  home.username = "tlmp59";
  home.homeDirectory = "/home/tlmp59";

  programs.zsh.enable = true;

  home.stateVersion = "23.11";
}
