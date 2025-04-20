{ config, lib, pkgs, mylib, myvar, ... }: { 
  home.username = myvar.user;
  home.homeDirectory = "/home/${myvar.user}";

  imports = mylib.scanPath ./.; 

  # ---Temp packages---
  # Should separate this into submodules
  home.packages = with pkgs; [
    tmux
    fzf
    tree
    tldr
    eza
    ripgrep
  ];

  home.file = {};
  home.sessionVariables = {};

  home.stateVersion = "24.11";
}
