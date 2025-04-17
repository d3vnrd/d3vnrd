{ inputs, lib, mylib, myvar, systems }: let
  inherit (inputs) home-manager nixpkgs;

  # WARN: same username but in different system directory can overide each others
  # --> Current approach is to make composite unique key for each user

  genUsers = system: lib.listToAttrs ( map (username: rec {
    name = "${username}_${myvar.suffix.${system}}"; 
    value = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ 
        {
	  home.username = "${name}";
	  home.homeDirectory = "/home/${name}";
	  home.stateVersion = "24.11";
	}
	../home # --> Home modules

	./${system}/${username}
      ];
    };
  }) (mylib.dirsIn ./${system}) );

in { homeConfigurations = lib.mergeAttrsList ( map genUsers systems ); }
