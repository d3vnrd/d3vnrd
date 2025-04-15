{ inputs, lib, mylib, myvar, systems }@specialArgs: let
  inherit (inputs) nix-darwin home-manager;

  genHosts = system: let
    sysHosts = mylib.dirsIn ./${system};

    sysAttrs = if lib.hasSuffix "darwin" system then {
      type = "darwin";
      init = nix-darwin.lib.darwinSystem;
      home = home-manager.darwinModules;
    } else {
      type = "linux";
      init = lib.nixosSystem;
      home = home-manager.nixosModules;
    };

  in with sysAttrs;
    lib.genAttrs sysHosts (
      hostname: init {
        inherit system specialArgs;
        modules = [
	  ./${system}/${hostname}
	  ../module/${type} 
	  home.home-manager

	  { 
	    users.users."${myvar.user}" = {
	        isNormalUser = true;
	        extraGroups = [ "wheel" ];
	    };

	    home-manager.users."${myvar.user}".imports = [ 
	      ../home # --> Default for any users
	      ./${system}/${hostname}/home.nix 
	    ];

	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = { inherit mylib myvar; };

	    networking.hostName = hostname;
	  }
        ];
      }
    );

in {
  nixosConfigurations = lib.mergeAttrsList ( map genHosts 
    ( builtins.filter (dir: lib.hasSuffix "linux" dir) systems )
  );

  darwinConfigurations = lib.mergeAttrsList ( map genHosts 
    ( builtins.filter (dir: lib.hasSuffix "darwin" dir) systems )
  );
}
