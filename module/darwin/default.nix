{ mylib, ... }:
let
  features = mylib.loadModules ./feature;
in
{ imports = feature; }

