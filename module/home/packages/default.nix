{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.M;
in
  with lib; {
    imports = custom.scanPath {path = ./.;};

    home.packages = with pkgs;
      mkMerge [
        [
          tldr
          eza
          ripgrep
          gnumake
          pandoc
          nodejs_24
        ]
        cfg.addPkgs
      ];

    programs = {
      zoxide = {
        enable = true;
        enableZshIntegration = true;
        # enableBashIntegration = true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
        # enableBashIntegration = true;
      };

      yazi = {
        enable = true;
        settings = {
          mgr = {
            ratio = [0 3 5];
            show_hidden = true;
            sort_by = "extension";
            sort_dir_first = true;
            show_symlink = true;
          };
        };
        enableZshIntegration = true;
        # enableBashIntegration = true;
      };

      lazygit = {
        enable = true;
      };

      starship = {
        enable = true;
        settings = mkForce {
          add_newline = true;
          scan_timeout = 10;
        };
        enableZshIntegration = true;
        # enableBashIntegration = true;
      };

      zellij = {
        enable = true;
        settings = mkForce {
          simplified_ui = true;
          default_layout = "compact";
          mouse_mode = true;
        };
        enableZshIntegration = true;
        # enableBashIntegration = true;
      };
    };
  }
