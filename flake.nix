{
  description = "FrameworkOS";

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (nixpkgs) lib;
    
    mylib = import ./lib { inherit lib; };
    myvar = import ./var { inherit lib; };
    specialArgs = { inherit inputs lib mylib myvar; };

    forAllSystems = func: (lib.genAttrs (mylib.dirsIn ./host) func);
  in lib.mergeAttrsList [
    ( import ./sys specialArgs )

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

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
