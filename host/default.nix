{ inputs, lib, mlib, mvar }@specialArgs: let
  inherit (inputs) nix-darwin home-manager;

  genHosts = system: let
    sysHosts = mlib.dirsIn ./${system};

    sysAttrs = if lib.hasSuffix "darwin" system then {
      type = "darwin";
      conf = nix-darwin.lib.darwinSystem;
      home = home-manager.darwinModules;
    } else {
      type = "linux";
      conf = lib.nixosSystem;
      home = home-manager.nixosModules;
    };

  in with sysAttrs;
    lib.genAttrs sysHosts (
      hostname: conf {
        inherit system specialArgs;
        modules = [
	  ./${system}/${hostname} 
	  ../module ../module/${type} 
	  home.home-manager

	  { 
	    users.users = {
	      ${mvar.user} = {
	        isNormalUser = true;
	        extraGroups = [ "wheel" ];
	      };
	    };

	    home-manager.users = {
	      "${mvar.user}" = import ./${system}/${hostname}/home.nix;
	    };

	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpeicalArgs = { inherit inputs mlib mvar };

	    networking.hostName = hostname;
	  }
        ];
      }
    );

in {
  nixosConfigurations = lib.mergeAttrsList
    ( map genHosts mvar.systems.linux);

  darwinConfigurations = lib.mergeAttrsList
    ( map genHosts mvar.systems.darwin);
}
