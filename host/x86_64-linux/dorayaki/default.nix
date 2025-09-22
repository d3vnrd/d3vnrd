{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
  ];

  M.disk = {
    device = "dev/nvme0";
    format = "btrfs-default";
    swap = 4;
  };
}
