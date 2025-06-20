{
  pkgs,
  lib,
  mylib,
  myvar,
  ...
}: {
  imports = mylib.scanPath ./.;

  config.module = with lib; {
    editor.enable = mkDefault true;
    shell.enable = mkDefault true;
    programs.enable = mkDefault [
      "fzf"
      "yazi"
      "lazygit"
      "zoxide"
    ];
  };

  config.home = {
    username = myvar.user;
    homeDirectory = "/home/${myvar.user}";
    packages = with pkgs; [
      tldr
      eza
      ripgrep
      gnumake
      pandoc
    ];

    file = {};
    sessionVariables = {};
    stateVersion = myvar.version;
  };
}
