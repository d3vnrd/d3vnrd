{
  description = "Suckless NixOs";

  # ---------------------------------------------------------------------
  # An attribute set that defines dependencies of a flake which will
  # be passed as arguments to the outputs function after fetching:
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  # ---------------------------------------------------------------------
  # A function that takes the dependencies from inputs as its parameters,
  # and its return value is an attribute set, which represents the build
  # results of the flake:
  outputs = { self, nixpkgs, ... } @ inputs: 
    let
      # Assgin hosts with system architectures
      systems = {
        "sl-laptop" = "x86_64-linux";
      };

      forEachHost = nixpkgs.lib.genAttrs (builtins.attrNames systems);
      forEachArchitecture = nixpkgs.lib.genAttrs (nixpkgs.lib.unique (builtins.attrValues systems));
    in 
    {
      nixosConfigurations = forEachHost (
        hostname: nixpkgs.lib.nixosSystem {
	  system = systems.${hostname};
          specialArgs = { inherit inputs; };
          modules = [
	    { networking.hostName = hostname; }
            ./hosts/${hostname}/configuration.nix
	    ./modules
          ];
        }
      );

      formatter = forEachArchitecture (
        architecture: nixpkgs.legacyPackages.${architecture}.alejandra
      );
    };
  # ---------------------------------------------------------------------
}
