{
  lib,
  mylib,
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
]
