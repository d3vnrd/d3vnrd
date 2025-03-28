{
  description = "FrameworkOS";

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (nixpkgs) lib;
    
    util = import ./util { inherit lib; };
    specialArgs = { inherit inputs lib util; };

  in with util; lib.mergeAttrsList [
    ( import ./host specialArgs )

    {
      formatter = mylib.forSystems (
	system: nixpkgs.legacyPackages.${system}.alejandra
      );
    }
  ];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-darwin.url = "github:/nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };
}
