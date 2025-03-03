{ self, nixpkgs, ... } @ inputs: let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib { inherit lib;};
  args = { inherit inputs lib mylib; };

  nixosSystems = [
    import ./x86_64-linux args
  ];

  forAllSystems = func: (lib.genAttrs (mylib.getDirNames ./.) func);
in {
  nixosConfigurations = import ./x86_64-linux args;

  formatter = forAllSystems (
    system: nixpkgs.legacyPackages.${system}.alejandra
  );
}

