{ config, pkgs, mylib, myvar, ... }: { 
  home.username = myvar.user;
  home.homeDirectory = "/home/${myvar.user}";

  imports = mylib.scanPath ./.; 

  # ---Temp packages---Belgrieve
  # Should separate this into submodules
  home.packages = with pkgs; [
    neovim
    tmux
    bat
    fzf
    zoxide
    tldr
    eza
    ripgrep
  ];

  home.file = {};
  home.sessionVariables = {
    EDITOR = "neovim --clean";
  };

  home.stateVersion = "24.11";
}
