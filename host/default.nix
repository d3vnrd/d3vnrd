{ inputs, lib, util, ... }@specialArgs: let
  inherit (inputs) nix-darwin home-manager;
  inherit (util) myvar mylib;

  genHosts = system: let
    sysHosts = mylib.dirsIn ./${system};

    sysAttrs = if lib.hasSuffix "darwin" system then {
      type = "darwin";
      func = nix-darwin.lib.darwinSystem;
      home = home-manager.darwinModules.home-manager;
    } else {
      type = "linux";
      func = lib.nixosSystem;
      home = home-manager.nixosModules.home-manager;
    };

  in with sysAttrs;
    lib.genAttrs sysHosts (
      hostname: func {
        inherit system specialArgs;
        modules = [
	  ./${system}/${hostname}/configuration.nix
	  ( mylib.relativeToRoot "module/${type}" )
	  {
	    # ---General---
	    networking.hostName = hostname;
	    nix.settings.experimental-features = [ "nix-command" "flakes" ];
	    time.timeZone = "Asia/Vietnam";

	    # ---Users---
	    users.users.${myvar.user} = {
	      isNormalUser = true;
	      extraGroups = [ "wheel" ];
	    };

	    # ---Reduce disk usage---
	    nix.gc = {
	      automatic = true;
	      dates = "weekly";
	      options = "--delete-older-than 1w";
	    };
	    nix.settings.auto-optimise-store = true;
	  }
        ];
      }
    );

in {
  nixosConfigurations = lib.mergeAttrsList
    ( map genHosts myvar.systems.linux);

  darwinConfigurations = lib.mergeAttrsList
    ( map genHosts myvar.systems.darwin);
}
