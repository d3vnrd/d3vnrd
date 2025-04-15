{ inputs, ... }:with inputs; 
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl.enable = true;
  wsl.defaultUser = "tlmp59";

  users.users.tlmp59.isNormalUser = true;

  system.stateVersion = "24.11";
}
