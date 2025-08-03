{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.M.disable = {
    fromPackages = mkOption {
      type = with types; listOf package;
      default = [];
      description = "List of packages to be disabled.";
    };

    fromPrograms = mkOption {
      type = with types; listOf str;
      default = [];
      description = "List of programs to be disabled.";
    };
  };

  config.home.packages = with pkgs;
    builtins.filter
    (p: !(builtins.elem p config.M.disable.fromPackages)) [
      tldr
      eza
      ripgrep
      gnumake
      pandoc
      nodejs_24
    ];

  config.programs = let
    check = p: !(builtins.elem p config.M.disable.fromPrograms);
    zsh = config.programs.zsh.enable;
  in {
    zoxide = {
      enable = mkDefault (check "zoxide");
      enableZshIntegration = mkDefault zsh;
      enableBashIntegration = mkDefault (!zsh);
      options = [];
    };

    fzf = {
      enable = mkDefault (check "fzf");
      enableZshIntegration = zsh;
      enableBashIntegration = !zsh;
    };

    yazi = {
      enable = mkDefault (check "yazi");
      settings = mkForce {
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

    lazygit = {
      enable = mkDefault (check "lazygit");
      settings = {};
    };

    starship = {
      enable = mkDefault (check "starship");
      settings = mkForce {
        add_newline = true;
        scan_timeout = 10;
      };
      enableZshIntegration = zsh;
      enableBashIntegration = !zsh;
    };

    zellij = {
      enable = mkDefault (check "zellij");
      settings = mkForce {
        theme = "kanagawa";
        simplified_ui = true;
        default_shell =
          if zsh
          then "zsh"
          else "bash";
        default_layout = "compact";
        mouse_mode = true;
      };
      enableZshIntegration = zsh;
      enableBashIntegration = !zsh;
    };
  };
}
