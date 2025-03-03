{ mylib, lib, ... } @ args: let
  system = builtins.baseNameOf ./.;
  hosts = mylib.getDirNames ./.;
in {
  sl-laptop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit args; };
    modules = [ 
      ./${hostname}/configuration.nix
      ../../module 
    ];
  };
}

