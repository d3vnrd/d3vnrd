{ inputs, lib, mylib, myvar, systems } @ specialArgs: let
  inherit (inputs) nix-darwin home-manager;

  # ---Host generating function---
  genHosts = system: let
    sysHosts = mylib.dirsIn ./${system};

    sysAttrs = if lib.hasSuffix "darwin" system then {
      type = "darwin";
      conf = nix-darwin.lib.darwinSystem;
      hmodule = home-manager.darwinModules;
    } else {
      type = "linux";
      conf = lib.nixosSystem;
      hmodule = home-manager.nixosModules;
    };

  in with sysAttrs;
    lib.genAttrs sysHosts (
      hostname: conf {
        inherit system specialArgs;
        modules = [
	  ./${system}/${hostname}
	  hmodule.home-manager
	  { 
	    users.users."${myvar.user}" = {
	        isNormalUser = true;
	        extraGroups = [ "wheel" ];
	    };

	    home-manager.users."${myvar.user}".imports = [ 
	      ../home # --> Home modules
	      ./${system}/${hostname}/home.nix
	    ];

	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = { inherit mylib myvar; };

	    networking.hostName = hostname;
	  }

	  ../module ../module/${type}
        ];
      }
    );
  # ------------------------------

in {
  nixosConfigurations = lib.mergeAttrsList ( map genHosts 
    ( builtins.filter (dir: lib.hasSuffix "linux" dir) systems )
  );

  darwinConfigurations = lib.mergeAttrsList ( map genHosts 
    ( builtins.filter (dir: lib.hasSuffix "darwin" dir) systems )
  );
}
