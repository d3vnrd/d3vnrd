{ lib, mylib, nixpkgs, home-manager, ... } @ args: let
  genUsers = system: let
    users = mylib.filesIn ./${system};
  in lib.genAttrs users (
    username: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system}; 
      extraSpecialArgs = args;
      modules = [ 
	./${system}/${username}.nix
	../module/home
      ];
    };
  );

in {
  homeConfigurations = lib.mergeAttrsList
    ( map genUsers (mylib.dirsIn ./.) )
}

