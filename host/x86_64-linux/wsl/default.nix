{ pkgs, inputs, myvar, ... }: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl.enable = true;
  wsl.defaultUser = "tlmp59";

  users.users."${myvar.user}" = {
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  }; 

  system.stateVersion = "24.11";
}
