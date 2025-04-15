{ config, pkgs, myvar, ... }:{
  home.username = myvar.user;
  home.homeDirectory = "/home/${myvar.user}";

  programs.zsh.enable = true;

  home.stateVersion = "24.11";
}
