{ pkgs, lib, config, inputs, helper, ... }:
let
  services = helper.loadModules ./service;
  features = helper.loadModules ./feature;
  extras = helper.loadModules ./extra;
  home = helper.loadModules ./home;
in
{ imports = services ++ features ++ extras ++ home; }

