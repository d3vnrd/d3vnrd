{
  lib,
  mylib,
  pkgs,
  ...
}:
lib.mkMerge [
  {
    default = pkgs.mkShell {
      packages = with pkgs; [
        python3
      ];
      name = "Default developing environment.";
      shellHook = ''
        python3 --version
        exec zsh
      '';
    };
  }

  (lib.genAttrs (mylib.scanPath ./.) (
    env: pkgs.mkShell (import ./${env} pkgs)
  ))
]
