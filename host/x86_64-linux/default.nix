{ mylib, lib, ... } @ args: let
  system = builtins.baseNameOf ./.;
  hosts = mylib.getDirNames ./.;
in 
  lib.genAttrs hosts (hostname: lib.nixosSystem {
    inherit system;
    specialArgs = { inherit args; };
    modules = [ ./${hostname}/configuration.nix ../module ];
  });

