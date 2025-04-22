{ config, lib, pkgs, mylib, myvar, ... }: { 
  imports = mylib.scanPath ./.; 

  options = {
    # ...
  };

  config = {
    home.username = myvar.user;
    home.homeDirectory = "/home/${myvar.user}";

    programs = {
      zsh.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
    };

    home.packages = with pkgs; [
      fzf
      tldr
      eza
      ripgrep
    ];

    home.file = {};
    home.sessionVariables = {};
    home.stateVersion = "24.11";
  };
}
