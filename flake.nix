{
  description = "FrameworkOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs : let
    inherit (nixpkgs) lib;
    mylib = import ./lib { inherit lib; };
    args = { inherit inputs lib mylib; };
    for_all_systems = func: (lib.genAttrs (mylib.getDirNames ./host) func);
  in {
    nixosConfigurations = import ./host/x86_64-linux args;
    formatter = for_all_systems (
      system: nixpkgs.legacyPackages.${system}.alejndra
    );
  };
}
