{
  inputs,
  lib,
  mylib,
  systems,
}: let
  inherit (inputs) nix-darwin home-manager;

  genHosts = system: let
    sysHosts = mylib.scanPath {
      path = ./${system};
      full = false;
      filter = "dir";
    };
    sysAttrs =
      if lib.hasSuffix "darwin" system
      then {
        type = "darwin";
        hmod = "darwinModules";
        init = nix-darwin.lib.darwinSystem;
      }
      else {
        type = "linux";
        hmod = "nixosModules";
        init = lib.nixosSystem;
      };
    specialArgs = {inherit inputs lib mylib;};
  in
    with sysAttrs;
      lib.genAttrs sysHosts (
        hostname:
          init {
            inherit system specialArgs;
            modules = [
              # --Include system configurations--
              ../module/base
              ../module/${type}
              ./${system}/${hostname}/configuration.nix

              # --Input home-manager as flake module--
              home-manager.${hmod}.home-manager

              # --System predefined attributes--
              {
                home-manager.users."${mylib.global.username}".imports = [
                  ../home/base
                  ../home/${type}
                  ./${system}/${hostname}/home.nix
                ];

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {inherit mylib;};

                networking.hostName = hostname;
              }
            ];
          }
      );
in {
  nixosConfigurations = lib.mergeAttrsList (
    map genHosts
    (builtins.filter (dir: lib.hasSuffix "linux" dir) systems)
  );

  darwinConfigurations = lib.mergeAttrsList (
    map genHosts
    (builtins.filter (dir: lib.hasSuffix "darwin" dir) systems)
  );
}
