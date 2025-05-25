{ inputs, pkgs, myvar, ... }: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  users.users."${myvar.user}" = {
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
  };

  wsl.enable = true;
  wsl.defaultUser = "${myvar.user}";

  wsl.docker-desktop.enable = false;
  # Required packages for docker support
  wsl.extraBin = with pkgs; [
    { src = "${coreutils}/bin/cat"; }
    { src = "${coreutils}/bin/whoami"; }
    { src = "${busybox}/bin/addgroup"; }
    { src = "${su}/bin/groupadd"; }
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  vscode-remote-workaround.enable = true;

  system.stateVersion = "24.11";
}
