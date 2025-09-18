{
  description = "Minimal flake for bootstraping NixOs systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
    helper = import ../module lib;

    genOs = {
      hostname,
      system,
      opts ? {
        networking.hostName = hostname;
      },
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs helper;};

        modules = [
          inputs.disko.nixosModules.disko
          ./${system}/${hostname}/hardware-configuration.nix
          opts
        ];
      };
  in {
    nixosConfigurations = {
      "wsl" = genOs {
        host = "wsl";
        system = "x86_64-linux";
      };

      "laptop" = genOs {
        host = "laptop";
        system = "aarch64-linux";
      };
    };
  };
}
