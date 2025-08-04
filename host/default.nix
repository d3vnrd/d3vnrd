{
  inputs,
  lib,
  ...
} @ args:
with inputs; let
  genHosts = system: let
    sysHosts = lib.custom.scanPath {
      path = ./${system};
      full = false;
      filter = "dir";
    };

    sysAttrs =
      if lib.hasSuffix "darwin" system
      then {
        type = "darwin";
        module = "darwinModules";
        init = nix-darwin.lib.darwinSystem;
      }
      else {
        type = "linux";
        module = "nixosModules";
        init = lib.nixosSystem;
      };

    specialArgs = {
      inherit inputs lib;
      var = nix-secret.globalVars;
    };
  in
    with sysAttrs;
      lib.genAttrs sysHosts (
        hostname:
          init {
            inherit system specialArgs;
            modules = [
              # --Include system configurations--
              ../module/system
              ./${system}/${hostname}

              # --Input home-manager & nix-secret as flake module--
              home-manager.${module}.home-manager
              nix-secret.${module}.secrets

              # --System predefined attributes--
              {
                home-manager.users."${nix-secret.globalVars.username}".imports = [
                  nix-secret.homeModules.secrets
                  ../module/home
                  ./${system}/${hostname}/home.nix
                ];

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {inherit (specialArgs) inputs var;};

                networking.hostName = hostname;
              }
            ];
          }
      );
in {
  nixosConfigurations = lib.mergeAttrsList (
    map genHosts
    (builtins.filter (dir: lib.hasSuffix "linux" dir) args.systems)
  );

  darwinConfigurations = lib.mergeAttrsList (
    map genHosts
    (builtins.filter (dir: lib.hasSuffix "darwin" dir) args.systems)
  );
}
