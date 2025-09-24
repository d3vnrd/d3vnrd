{
  description = "FrameworkOS";

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
    helper = import ./module lib;

    systems = helper.scanPath {
      path = ./host;
      full = false;
      filter = "dir";
    };

    forSystems = func: (lib.genAttrs systems func);
  in
    lib.mergeAttrsList [
      (import ./host {inherit inputs systems helper;})

      {
        formatter = forSystems (
          system: nixpkgs.legacyPackages.${system}.alejandra
        );

        checks = forSystems (
          system: let
            inherit (inputs) pre-commit-hooks;
            pkgs = nixpkgs.legacyPackages.${system};
          in
            helper.checkFunc {inherit pre-commit-hooks system pkgs;}
        );

        devShells = forSystems (
          system: let
            pkgs = nixpkgs.legacyPackages.${system};
          in (import ./shell {inherit lib pkgs helper;})
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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    stylix.url = "github:danth/stylix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    secrets = {
      url = "git+ssh://git@github.com/d3vnrd/secrets.git?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
