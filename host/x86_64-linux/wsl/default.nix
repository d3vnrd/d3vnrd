{ pkgs, inputs, myvar, ... }: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl.enable = true;
  wsl.defaultUser = "tlmp59";

  system.stateVersion = "24.11";
}
