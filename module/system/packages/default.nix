{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.M;
in
  with lib; {
    imports = lib.custom.scanPath {path = ./.;};

    options.M = {
      addPkgs = mkOption {
        type = with types; listOf package;
        default = [];
        description = "Additional packages (beside default).";
      };
    };

    # --Binaries declaration--
    environment.systemPackages = with pkgs;
      lib.mkMerge [
        [
          # utils
          gh
          gcc
          unzip
          direnv
          just

          # networking
          wget
          curl

          # synchronize
          rsync
          neovim
        ]

        # additional specific host packages
        cfg.addPkgs
      ];

    # --Configurable-via-flake programs--
    programs = {
      zsh.enable = true;
      git.enable = true;
    };
  }
