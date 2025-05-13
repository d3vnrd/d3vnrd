{
  lib,
  pkgs,
  mylib,
  myvar,
  ...
}: {
  imports = mylib.scanPath ./.;

  config = {
    home.username = myvar.user;
    home.homeDirectory = "/home/${myvar.user}";

    # ~ temporary enable packages
    programs = {
      zsh.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
      lazygit.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      fzf.enable = lib.mkDefault true;
    };

    home.packages = with pkgs; [
      tldr
      eza
      ripgrep
      make
    ];

    home.file = {};
    home.sessionVariables = {};
    home.stateVersion = "24.11";
  };
}
