{ lib, mylib, inputs, ... }@extraSpecialArgs: let
  inherit (inputs) nixpkgs home-manager;

  genUsers = system: let
    users = mylib.filesIn ./${system};
  in lib.genAttrs users (
    username: home-manager.lib.homeManagerConfiguration {
      inherit extraSpecialArgs;
      pkgs = nixpkgs.legacyPackages.${system}; 
      modules = ( map mylib.relativeToRoot [ 
	"usr/${system}/${username}.nix"
	"module/home"
      ]);
    }
  );

in {
  homeConfigurations = lib.mergeAttrsList
    ( map genUsers (mylib.dirsIn ./.) );
}

