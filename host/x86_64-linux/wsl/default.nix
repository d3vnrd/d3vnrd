{ pkgs, inputs, myvar, ... }: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl.enable = true;
  wsl.defaultUser = "tlmp59";
  
  users.users."${myvar.user}" = {
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
  };

  system.stateVersion = "24.11";
}
