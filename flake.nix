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
      system = "x86_64-linux";

      # Add new hostname
      forAllHostnames = nixpkgs.lib.genAttrs [
	"suckless"
      ];
    in 
    {
      nixosConfigurations = forAllHostnames (hostName: nixpkgs.lib.nixosSystem {
	inherit system;

        # Set all inputs parameters as special arguments for all submodules,
        # making it possible to directly use all dependencies in inputs in
        # submodules. For instance, after applying the inputs parameter can
        # now be used in ./configuration.nix to install software from other
        # dependencies.
        specialArgs = { inherit inputs; };

        modules = [
	  { networking.hostName = hostName; }
          ./hosts/${hostName}/configuration.nix
	  ./modules
        ];
      });
    };
  # ---------------------------------------------------------------------
}
