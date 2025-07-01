{
  inputs,
  system,
  pkgs,
  ...
}:
with inputs; {
  pre-commit-check = pre-commit-hooks.lib.${system}.run {
    src = ../.;
    hooks = {
      alejandra.enable = true;
    };
  };
}
