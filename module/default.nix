{ mylib, ... }:
let
  services = mylib.loadModules ./service;
  features = mylib.loadModules ./feature;
  extras = mylib.loadModules ./extra;
  home = mylib.loadModules ./home;
in
{ imports = services ++ features ++ extras ++ home; }

