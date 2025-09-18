{
  lib,
  pkgs,
  helper,
  ...
}:
with lib;
  mergeAttrsList [
    {
      default = pkgs.mkShell {
        packages = with pkgs; [
          python3
          uv
          hugo
          go
        ];
        shellHook = ''
          echo "Unified default shell!"
          exec zsh
        '';
        name = "default";
      };
    }

    (
      genAttrs (
        map (file: removeSuffix ".nix" file) (
          helper.scanPath {
            path = ./.;
            full = false;
            filter = "file";
          }
        )
      )
      (name: pkgs.mkShell (import (./. + "/${name}.nix") pkgs))
    )
  ]
