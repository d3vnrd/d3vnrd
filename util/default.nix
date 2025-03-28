{ lib }: rec {
  mylib = import ./lib.nix { inherit lib;};
  myvar = import ./var.nix { inherit lib mylib;};
}
