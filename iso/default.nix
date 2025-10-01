{modulesPath, ...}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  networking.useDHCP = true;
  networking.wireless.enable = false;

  services.getty.autologinUser = "root";
  services.getty.helpLine = ''

    Log in as root (automatic) and run 'ip addr' to see your IP address.
    SSH is enabled with key-based authentication.
  '';

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJbMqB4TivYvpKp... your-key@laptop"
  ];
}
