{
  description = "FrameworkOS";

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    lib = nixpkgs.lib.extend (self: super: {
      custom = import ./module nixpkgs.lib;
    });

    systems = lib.custom.scanPath {
      path = ./host;
      full = false;
      filter = "dir";
    };

    forSystems = func: (lib.genAttrs systems func);
  in
    lib.mergeAttrsList [
      (import ./host {inherit inputs lib systems;})

      {
        formatter = forSystems (
          system: nixpkgs.legacyPackages.${system}.alejandra
        );

        checks = forSystems (
          system: let
            inherit (inputs) pre-commit-hooks;
            pkgs = nixpkgs.legacyPackages.${system};
          in
            lib.custom.checkFunc {inherit pre-commit-hooks system pkgs;}
        );

        devShells = forSystems (
          system: let
            pkgs = nixpkgs.legacyPackages.${system};
          in (import ./shell {inherit lib pkgs;})
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

    # --Pre-commit--
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --Theming framework--
    stylix.url = "github:danth/stylix";

    # --Wsl support--
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # --User secret--
    nix-secret.url = "git+ssh://git@github.com/tlmp59/nix-secret.git?ref=main&shallow=1";

    # -- Neovim Nightly --
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
}
