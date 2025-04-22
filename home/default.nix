{ config, lib, pkgs, mylib, myvar, ... }: { 
  home.username = myvar.user;
  home.homeDirectory = "/home/${myvar.user}";

  imports = mylib.scanPath ./.; 

  # ---Packages with options---
  programs.zsh.enable = true;
  programs.git.enable = true;
  programs.neovim.enable = true;

  # ---Packages without options---
  home.packages = with pkgs; [
    tmux
    fzf
    tldr
    eza
    ripgrep
  ];

  home.file = {};
  home.sessionVariables = {};
  home.stateVersion = "24.11";
}
