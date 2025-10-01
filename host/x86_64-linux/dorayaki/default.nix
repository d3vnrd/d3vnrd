{...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = true;

  users.users."tlmp59" = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQyVlweJ2+noPOb3/PwBn9xcuj/npJPz2T52Au8eoTT root@wsl"
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  M.disk = {
    device = "/dev/sda";
    format = "btrfs-default";
    swap = 2;
  };
}
