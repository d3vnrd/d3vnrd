{ lib, mylib, nixpkgs, home-manager, ... } @ args: let
  genUsers = system: let
    users = mylib.filesIn ./${system};
    setting = {
      pkgs = nixpkgs.legacyPackages.${system}; 
      extraSpecialArgs = args;
      modules = [ 
	./${system}/${username} 
	../module/home
      ];
    };
  in lib.genAttrs users (
    username: home-manager.lib.homeManagerConfiguration setting
  );
in {
  #NOTE: user should be present on either standalone system or global accross other system
  # --> Current approach only allows for specific system, for global purposes this require user.nix file to be present in all system folder, which is inefficient.
  homeConfigurations = lib.mergeAttrsList [
    genUsers
  ];
}

