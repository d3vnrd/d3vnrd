{
  lib,
  helper,
  ...
}:
with lib; {
  imports = helper.scanPath {
    path = ./.;
    exclude = ["nixos" "darwin"];
  };
  time.timeZone = mkDefault "Asia/Vietnam";
}
