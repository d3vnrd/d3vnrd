{ pkgs, mvar, ... }: {
  home.username = mvar.user;
  home.homeDirectory = "/home/${mvar.user}";

  home.packages = with pkgs; [
    neovim
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "neovim --clean";
  };

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
  programs.git = {
    enable = true;
    userName = "tlmp59";
    userEmail = "tinng.imp@gmail.com";
  };

  home.stateVersion = "24.11";
}
