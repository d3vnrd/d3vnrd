{
  description = "FrameworkOS";

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;

    mylib = import ./lib lib;
    systems = mylib.scanPath {
      path = ./host;
      full = false;
      filter = "dir";
    };
    args = {inherit inputs lib mylib systems;};

    forSystems = func: (lib.genAttrs systems func);
  in
    lib.mergeAttrsList [
      (import ./host args)

      {
        formatter = forSystems (
          system: nixpkgs.legacyPackages.${system}.alejandra
        );

        checks = forSystems (
          system: let
            pkgs = nixpkgs.legacyPackages.${system};
          in (import ./lib/check.nix {inherit inputs system pkgs;})
        );

        devShells = forSystems (
          system: let
            pkgs = nixpkgs.legacyPackages.${system};
          in (import ./shell {inherit lib mylib pkgs;})
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
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --Declarative partitioning--
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --Theming framework--
    stylix.url = "github:danth/stylix";

    # --Secrets management--
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --Pre-commit--
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --Wsl support--
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };
}
