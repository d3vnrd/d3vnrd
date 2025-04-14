{
  description = "FrameworkOS";

  outputs = { nixpkgs, ... }@inputs: let
    inherit (nixpkgs) lib;
    
    mlib = import ./lib { inherit lib; };
    mvar = import ./var { inherit lib mlib; };
    specialArgs = { inherit inputs lib mlib mvar; };

  in lib.mergeAttrsList [
    ( import ./host specialArgs )

    {
      formatter = mfunc.forSystems (
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
