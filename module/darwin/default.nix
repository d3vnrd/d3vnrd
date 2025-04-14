{ mlib, ... }:{ imports = mlib.scanPath ./. ++ [ ../default.nix ]; }

