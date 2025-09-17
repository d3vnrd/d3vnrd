{
  inputs,
  lib,
  systems,
  ...
}:
with lib; let
  inherit (inputs) home-manager nix-darwin nix-secret;

  genConfig = system: let
    hosts = custom.scanPath {
      path = ./${system};
      full = false;
      filter = "dir";
    };

    opts =
      if hasSuffix "darwin" system
      then {
        type = "darwin";
        bootstrap = nix-darwin.lib.darwinSystem;
      }
      else {
        type = "nixos";
        bootstrap = nixosSystem;
      };
  in
    genAttrs hosts (
      hostname:
        with opts;
          bootstrap {
            inherit system;
            specialArgs = {inherit inputs lib;};

            modules = [
              # --Include system configurations--
              ../module/system
              ./${system}/${hostname}

              # --Input home-manager & nix-secret as flake module--
              home-manager."${type}Modules".home-manager
              nix-secret."${type}Modules".secrets

              # --System predefined attributes--
              #TODO: change username to devon
              {
                home-manager.users."tlmp59".imports = [
                  nix-secret.homeModules.secrets
                  ../module/home
                  {
                    home.username = "tlmp59";
                    home.stateVersion = "25.05";
                  }
                  ./${system}/${hostname}/home.nix
                ];

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {inherit inputs;};

                networking.hostName = hostname;
              }
            ];
          }
    );
in {
  nixosConfigurations = mergeAttrsList (
    map genConfig
    (builtins.filter (dir: hasSuffix "linux" dir) systems)
  );

  darwinConfigurations = mergeAttrsList (
    map genConfig
    (builtins.filter (dir: hasSuffix "darwin" dir) systems)
  );
}
