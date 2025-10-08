{helper, ...}: {
  imports = [
    (helper.fromRoot module/system/nixos/disk.nix)
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = true;

  users.users.nixos.openssh.authorizedKeys.keys = [
    (builtins.readFile ../wsl/key.pub)
  ];

  M.disk = {
    device = "/dev/sda";
    format = "btrfs-default";
    swap = 2;
  };
}
