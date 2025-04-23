{ config, lib, pkgs, mylib, myvar, ... }: { 
  imports = mylib.scanPath ./.; 

  options = {
    # ...
  };

  config = {
    home.username = myvar.user;
    home.homeDirectory = "/home/${myvar.user}";

    # ~ manager with xdg base directories
    xdg.enable = true;

    # ~ temporary enable packages
    programs = {
      zsh.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
      lazygit.enable = lib.mkDefault true;
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
