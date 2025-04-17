{ inputs, lib, mylib, myvar, systems }: let
  inherit (inputs) home-manager nixpkgs;

  # WARN: same username but in different system directory can overide each others
  # --> Current approach is to make composite unique key for each user

  genUsers = system: lib.listToAttrs ( map (name: {
    name = "${name}-${myvar.suffix.${system}}"; 
    value = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ 
        ./standalone.nix
	../home # --> Home modules
      ];
    };
  }) (mylib.dirsIn ./${system}) );

in { homeConfigurations = lib.mergeAttrsList ( map genUsers systems ); }
