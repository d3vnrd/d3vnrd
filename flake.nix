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
      formatter = mlib.forSystems (
	system: nixpkgs.legacyPackages.${system}.alejandra
      );
    }
  ];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-darwin.url = "github:/nixos/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Secrets management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Format nix before commit
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };
}
