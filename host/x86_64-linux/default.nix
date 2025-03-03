{ mylib, lib, ... } @ args: let
  system = builtins.baseNameOf ./.;
  hosts = mylib.getDirNames ./.;
in {
  sl_01 = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit args; };
    modules = [ 
      ./sl_01/configuration.nix
      ../../module 
    ];
  };
}

