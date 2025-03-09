{
  description = "FrameworkOS";

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (nixpkgs) lib;
    
    mylib = import ../lib { inherit lib; };
    specialArgs = { inherit inputs lib mylib; };

    forAllSystems = func: (lib.genAttrs (mylib.dirsIn ./host) func);
  in lib.mergeAttrsList [
    ( import ./host specialArgs )
    ( import ./usr specialArgs )
    {
      formatter = forAllSystems (
	system: nixpkgs.legacyPackages.${system}.alejandra
      );
    }
  ];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # nixpkgs-darwin.url = "github:/nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-darwin.url = "github:/nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
