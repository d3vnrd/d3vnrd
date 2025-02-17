{ pkgs, lib, config, inputs, ... }:
let
  helper = import ../helper.nix;

  services = helper.loadModules ./services;
  features = helper.loadModules ./features;
  extras = helper.loadModules ./extras;
in
{
  imports = services ++ features ++ extras;
}

