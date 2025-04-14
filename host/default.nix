{ inputs, lib, mlib, mvar }@specialArgs: let
  inherit (inputs) nix-darwin home-manager nixpkgs;

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
	  ../module/${type}
	  home.home-manager 

	  # ------------------------------Global------------------------------
	  { 
	    nix.settings.experimental-features = [ "nix-command" "flakes" ];
	    networking.hostName = hostname;
	    nixpkgs.config.allowUnfree = true;
	    time.timeZone = "Asia/Vietnam";

	    # ---Users---
	    users.users = {
	      "${mvar.user}" = {
	        isNormalUser = true;
	        extraGroups = [ "wheel" ];
	      };

	      # -> Add new user here:
	      # "<user-name>" = { <options> };
	    };

	    home-manager.users = {
	       ${mvar.user} = ./${system}/${hostname}/home.nix;

	       # -> Also here to manage with home:
	       # <user-name> = ./${system}/${hostname}/<user-name>.nix;
	    };

	    # ---General---
	    home-manager = {
	      useGlobalPkgs = true;
	      useUserPackages = true;
	      extraSpecialArgs = specialArgs;
	    };

	    # ---Reduce disk usage---
	    nix.gc = {
	      automatic = true;
	      dates = "daily";
	      options = "--delete-older-than 1w";
	    };
	    nix.settings.auto-optimise-store = true;
	  }
	  # ------------------------------------------------------------------
        ];
      }
    );

in {
  nixosConfigurations = lib.mergeAttrsList
    ( map genHosts mvar.systems.linux);

  darwinConfigurations = lib.mergeAttrsList
    ( map genHosts mvar.systems.darwin);
}
