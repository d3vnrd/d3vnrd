{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.M;
in
  with lib; {
    config.environment.systemPackages = with pkgs;
      if cfg.defaultPkgs
      then
        mkMerge [
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

          # default system specific packages
          (
            if cfg.system == "darwin"
            then []
            else []
          )

          # additional specific host packages
          cfg.addPkgs
        ]
      else cfg.addPkgs;
  }
