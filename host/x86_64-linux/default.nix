{ lib, mylib, ... }@specialArgs: modules: let
  hosts = mylib.getSubdirNames ./.;
in lib.genAttrs hosts ( hostname: lib.nixosSystem {
  inherit specialArgs;
  system = "x86_64-linux";
  modules = [
    ./${hostname}/configuration.nix
    modules
  ];
})
