{
  description = "FrameworkOS";

  outputs = { nixpkgs, ... }@inputs: let
    inherit (nixpkgs) lib;
    
    ulib = import ./ulib { inherit lib; };
    uvar = import ./uvar { inherit lib ulib; };
    specialArgs = { inherit inputs lib ulib uvar; };

  in lib.mergeAttrsList [
    # ---Fetch system configs---
    ( import ./host specialArgs )

    # ---Addtional options---
    {
      formatter = mlib.forSystems (
	system: nixpkgs.legacyPackages.${system}.alejandra
      );
    }
  ];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nixpkgs-darwin.url = "github:/nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # ---Secrets management---
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ---Precommit---
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ---Wsl support---
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };
}
