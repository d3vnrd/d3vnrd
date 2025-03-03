{ mylib, ... }:
let
  services = mylib.loadModules ./service;
  features = mylib.loadModules ./feature;
  extras = mylib.loadModules ./extra;
in
{ imports = services ++ features ++ extras; }

