{
  description = "FrameworkOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs : let
    inherit (nixpkgs) lib;
    mylib = import ./lib { inherit lib; };
    specialArgs = { inherit inputs lib mylib; };
    for_all_systems = func: (lib.genAttrs (mylib.getDirNames ./host) func);
  in {
    nixosConfigurations = {
      sl_01 = lib.nixosSystem {
	system = "x86_64-linux";
	inherit specialArgs;
	modules = [
	  ./host/x86_64-linux/sl_01/configuration.nix
	  ./module
	];
      };
    };

    formatter = for_all_systems (
      system: nixpkgs.legacyPackages.${system}.alejndra
    );
  };
}
