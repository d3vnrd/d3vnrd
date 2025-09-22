{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
  ];

  config = {
    M.disk = {
      device = "dev/nvme0";
      format = "btrfs-default";
      swap = 4;
    };
  };
}
