{ lib, mylib, myvar, inputs, ... }@specialArgs: let
  inherit (inputs) nix-darwin home-manager;

  genHosts = system: let
    sysAttrs = if lib.hasSuffix "darwin" system {
      type = "darwin";
      func = nix-darwin.lib.darwinSystem;
      home = home-manager.darwinModules.home-manager;
    } else {
      type = "linux";
      func = lib.nixosSystem;
      home = home-manager.nixosModules.home-manager;
    };

  in with sysAttrs;
    lib.genAttrs mylib.dirsIn ./${system} (
      hostname: func {
        inherit system specialArgs;
        modules = [
	  ./${system}/${hostname}/configuration.nix
	  ( mylib.relativeToRoot "module/${type}")
	
          home {
	    home-manager = {
	      useGlobalPkgs = true;
	      useUserPackages = true;
	      extraSpeicalArgs = specialArgs;
	      users.${myvar.user} = import
		./${system}/${hostname}/home.nix;
	    }; 
	  }
        ];
      }
    );

in {
  nixosConfigurations = lib.mergeAttrsList [
    ( map genHosts myvar.systems.linux)
  ];

  darwinConfigurations = lib.mergeAttrsList [
    ( map genHosts myvar.systems.darwin)
  ];
}
