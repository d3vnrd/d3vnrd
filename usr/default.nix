{ inputs, lib, mylib, systems, ...}: let
  inherit (inputs) home-manager nixpkgs;

  # WARN: same username but in different system directory can overide each others
  genUsers = system: lib.genAttrs ( mylib.dirsIn ./${system} ) (
    username: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        ./standalone.nix
	../home # --> Home modules
      ];
    }
  );

in { homeConfigurations = lib.mergeAttrsList ( map genUsers systems ); }
