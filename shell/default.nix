{
  lib,
  pkgs,
  ...
}:
lib.mergeAttrsList [
  {
    default = pkgs.mkShell {
      packages = with pkgs; [
        python3
        uv
      ];
      shellHook = ''
        echo "Unified default shell!"
        exec zsh
      '';
      name = "default";
    };
  }

  (
    lib.genAttrs (
      map (file: lib.removeSuffix ".nix" file) (
        lib.custom.scanPath {
          path = ./.;
          full = false;
          filter = "file";
        }
      )
    )
    (name: pkgs.mkShell (import (./. + "/${name}.nix") pkgs))
  )
]
