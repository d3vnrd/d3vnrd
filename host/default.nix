{
  inputs,
  lib,
  mylib,
  myvar,
  systems,
} @ specialArgs: let
  inherit (inputs) nix-darwin home-manager;

  genHosts = system: let
    sysHosts = mylib.dirsIn ./${system};
    sysAttrs =
      if lib.hasSuffix "darwin" system
      then {
        type = "darwin";
        conf = nix-darwin.lib.darwinSystem;
        hmod = home-manager.darwinModules;
      }
      else {
        type = "linux";
        conf = lib.nixosSystem;
        hmod = home-manager.nixosModules;
      };
  in
    with sysAttrs;
      lib.genAttrs sysHosts (
        hostname:
          conf {
            inherit system specialArgs;
            modules = [
              ../module
              ../module/${type}
              ./${system}/${hostname}
              hmod.home-manager
              {
                home-manager.users."${myvar.user}".imports = [
                  ../home
                  ./${system}/${hostname}/home.nix
                ];

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {inherit mylib myvar;};

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
