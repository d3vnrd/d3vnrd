{ lib, mylib, myvar, inputs, ... }@specialArgs: let
  inherit (inputs) nix-darwin home-manager;

  genHosts = {system, isDarwin ? false}: let
    sysFunc = if isDarwin 
      then nix-darwin.lib.darwinSystem else lib.nixosSystem;
    sysType = if isDarwin
      then "darwin" else "linux";
    sysHosts = mylib.dirsIn ./${system};

    homeFunc = if isDarwin
      then home-manager.darwinModules.home-manager
      else home-manager.nixosModules.home-manager;

  in lib.genAttrs sysHosts (
    hostname: sysFunc {
      inherit system specialArgs;
      modules = [
	./${system}/${hostname}/configuration.nix
	( mylib.relativeToRoot "module/${sysType}")

        homeFunc {
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;

	  home-manager.extraSpecialArgs = specialArgs;
	  home-manager.users.${myvar.defaultUser} = import ./host/${system}/${hostname}/home.nix;
	}
      ];
    }
  );

  genUsers = system: let
    users = mylib.filesIn ./${system};
  in lib.genAttrs users (
    username: home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = specialArgs;
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
	./${system}/usr/${username}.nix
	( mylib.relativeToRoot "module/home")
      ];
    }
  );

in {
  nixosConfigurations = lib.mergeAttrsList [
    (genHosts {system = "x86_64-linux";})
    (genHosts {system = "aarch64-linux";})
  ];

  darwinConfigurations = lib.mergeAttrsList [
    (genHosts {system = "x86_64-darwin"; isDarwin = true;})
    (genHosts {system = "aarch64-darwin"; isDarwin = true;})
  ];
  
  homeConfigurations = lib.mergeAttrsList 
    ( map genUsers (mylib.dirsIn ./. ) );
}
