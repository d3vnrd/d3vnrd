{
  description = "Minimal flake for bootstraping NixOs systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
    helper = import ../module lib;

    genInit = {
      hostname,
      system,
      opts ? {
        networking.hostName = hostname;
      },
    }: {
      "${hostname}" = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs helper;};

        modules = [
          inputs.disko.nixosModules.disko
          ./${system}/${hostname}/hardware-configuration.nix

          {}
          opts
        ];
      };
    };
  in {
    nixosConfigurations = lib.mergeAttrsList (
      map genInit [
        {
          hostname = "laptop";
          system = "x86_64-linux";
        }
        {
          hostname = "machine";
          system = "x86_64-linux";
        }
      ]
    );
  };
}
