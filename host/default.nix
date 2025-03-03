{ self, nixpkgs, ... } @ inputs: let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib { inherit lib;};
  args = { inherit inputs lib mylib; };

  nixosSystems = [
    import ./x86_64-linux args
    import ./aarch64-linux args
  ];

  darwinSystems = [
    import ./x86_64-darwin args
    import ./aarch64-darwin args
  ];

  forAllSystems = func: (lib.genAttrs (mylib.getDirNames ./.) func);
in {
  nixosConfigurations = lib.mergeAttrsList nixosSystems;
  darwinConfigurations = lib.mergeAttrsList darwinSystems;

  formatter = forAllSystems (
    system: nixpkgs.legacyPackages.${system}.alejandra
  );
}

