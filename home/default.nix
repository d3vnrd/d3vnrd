{
  pkgs,
  lib,
  mylib,
  myvar,
  ...
}: {
  imports = mylib.scanPath ./.;

  # -- Config available with Home-manager --
  programs = with lib; {
    yazi.enable = mkDefault true;
    lazygit.enable = mkDefault true;
    zoxide.enable = mkDefault true;
    fzf.enable = lib.mkDefault true;
  };

  home.packages = with pkgs; [
    tldr
    eza
    ripgrep
    gnumake
    pandoc
  ];

  home = {
    username = myvar.user;
    homeDirectory = "/home/${myvar.user}";
    file = {};
    sessionVariables = {};
  };

  home.stateVersion = myvar.version;
}
