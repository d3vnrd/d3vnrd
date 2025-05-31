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

    programs = {
      zsh.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      yazi = {
        enable = lib.mkDefault true;
        settings = {
          manager = {
            show_hidden = true;
            sort_by = "extension";
            sort_dir_first = true;
            sort_reverse = true;
            show_symlink = true;
          };
        };
        enableZshIntegration = true;
      };
      lazygit = {
        enable = lib.mkDefault true;
        settings = {};
      };
      zoxide = {
        enable = lib.mkDefault true;
        enableZshIntegration = true;
        options = [];
      };
      fzf = {
        enable = lib.mkDefault true;
        enableZshIntegration = true;
      };
    };

    user = {
        editor = {
	  enable = true;
	  onWsl = true;
	};
    };

    home.packages = with pkgs; [
      tldr
      eza
      ripgrep
      gnumake
      quarto
      pandoc
    ];

    home.file = {};
    home.sessionVariables = {};
    home.stateVersion = "24.11";
  };
}
