{ config, pkgs, mvar, ... }:{
  home.username = mvar.user;
  home.homeDirectory = "/home/${mvar.user}";

  programs.zsh.enable = true;

  home.stateVersion = "24.11";
}
