{
  description = "Suckless NixOs";

  inputs = {
    # An attribute set that defines dependencies of a flake which will
    # be passed as arguments to the outputs function after fetching.

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # A function that takes the dependencies from inputs as its parameters,
    # and its return value is an attribute set, which represents the build
    # results of the flake.

    # Flakes can have various purposes and can have different types of
    # outputs. For example, nixosConfigurations type of outputs can be used
    # to configure NixOs systems:
    nixosConfigurations.suckless = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Set all inputs parameters as special arguments for all submodules,
      # making it possible to directly use all dependencies in inputs in
      # submodules:
      specialArgs = { inherit inputs; };

      # For instance, after applying the inputs parameter can now be used in
      # ./configuration.nix to install software from other dependencies.

      modules = [
        ./configuration.nix
      ];
    };
  };
}
