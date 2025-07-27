{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.M;
in
  with lib; {
    config.home.packages = with pkgs;
      if cfg.defaultPkgs
      then
        mkMerge [
          []

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
