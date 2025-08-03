{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.M.state != "non-boot") {
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.supportedFilesystems = ["btrfs"];
  };
}
