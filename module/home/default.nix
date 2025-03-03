{ mylib, ... }:
let
  utils = mylib.loadModules ./util;
in
{ imports = util; }

