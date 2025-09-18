{
  config,
  lib,
  pkgs,
  helper,
  ...
}: let
  cfg = config.M;
in
  with lib; {
    imports = helper.scanPath {path = ./.;};

    options.M = {
      addPkgs = mkOption {
        type = with types; listOf package;
        default = [];
        description = "Additional packages (beside default).";
      };
    };

    config = {
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
            # neovim
          ]

          # additional specific host packages
          cfg.addPkgs
        ];

      # --Configurable-via-flake programs--
      programs = {
        # zsh.enable = mkIf (config.users.defaultUserShell == pkgs.zsh) (mkForce true);
        zsh.enable = true;
        git.enable = mkForce true;
      };
    };
  }
