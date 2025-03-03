{
  description = "FrameworkOS";

  outputs = { self, nixpkgs, ... } @ inputs : let
    inherit (nixpkgs) lib;

    mylib = import ./lib { inherit lib; };
    args = { inherit inputs lib mylib; };
  in {
    nixosConfigurations = lib.mergeAttrsList [
      (import ./host/x86_64-linux args ./module/nixos)
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
