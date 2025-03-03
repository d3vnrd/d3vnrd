{ lib, mylib, modules, ... }@specialArgs: let
  system = builtins.baseNameOf ./.;
  hosts = mylib.getSubdirNames ./.;
in lib.genAttrs hosts ( hostname: lib.nixosSystem {
  inherit system specialArgs;
  modules = [
    ./${hostname}/configuration.nix
    modules
  ];
})
