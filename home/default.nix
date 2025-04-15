{ config, pkgs, mvar, ... }: {
  home.username = mvar.user;
  home.homeDirectory = "/home/${mvar.user}";

  home.packages = with pkgs; [
    tmux 
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "neovim --clean";
  };

  programs.git = {
    enable = true;
    userName = "tlmp59";
    userEmail = "tinng.imp@gmail.com";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
