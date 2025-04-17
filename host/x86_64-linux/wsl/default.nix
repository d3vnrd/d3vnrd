{ inputs, ... }:with inputs; 
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl.enable = true;
  wsl.defaultUser = "tlmp59";

  users.users = {
    yamaha_x86l.isNormalUser = true; 
  };

  system.stateVersion = "24.11";
}
