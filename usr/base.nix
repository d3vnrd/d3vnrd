{ config, pkgs, myvar, ... }: {
  home.username = myvar.user;
  home.homeDirectory = "/home/${myvar.user}";

  # ---User packages
  home.packages = with pkgs; [
    neovim
    tmux 
    tree
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
