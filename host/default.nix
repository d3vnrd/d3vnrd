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
	  ./${system}/${hostname}/configuration.nix
	  ( mlib.relativeToRoot "module/${type}" )

	  { 
	    networking.hostName = hostname;
	    users.users = {
	      "${mvar.user}" = {
	        isNormalUser = true;
	        extraGroups = [ "wheel" ];
	      };
	      # ---Add new global user here---
	    };
	  }

	  home.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = specialArgs;
            home-manager.users = {
	      "${mvar.user}".imports = [
	        ./${system}/${hostname}/home.nix
		( mlib.relativeToRoot "module/home")
	      ];
	      # ---Don't forget here aswell---
	    };
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
