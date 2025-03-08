{
  description = "FrameworkOS";

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (nixpkgs) lib;
    
    mylib = import ../lib { inherit lib; };
    specialArgs = { inherit inputs lib mylib; };

    forAllSystems = func: (lib.genAttrs (mylib.dirsIn ./.) func);
  in lib.mergeAttrsList [
    ( import ./host specialArgs )
    #( import ./usr specialArgs )
    {
      formatter = forAllSystems (
	system: nixpkgs.legacyPackages.${system}.alejandra
      );
    }
  ];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
