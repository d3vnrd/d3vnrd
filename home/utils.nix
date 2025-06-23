{config, ...}: let
  zsh = config.programs.zsh.enable;
in {
  programs = {
    lazygit.settings = {};

    zoxide = {
      enableZshIntegration = zsh;
      enableBashIntegration = !zsh;
      options = [];
    };

    fzf = {
      enableZshIntegration = zsh;
      enableBashIntegration = !zsh;
    };

    yazi = {
      settings = {
        mgr = {
          ratio = [0 3 5];
          show_hidden = true;
          sort_by = "extension";
          sort_dir_first = true;
          sort_reverse = true;
          show_symlink = true;
        };
      };
      enableZshIntegration = zsh;
      enableBashIntegration = !zsh;
    };
  };
}
