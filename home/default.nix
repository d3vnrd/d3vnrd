{
  pkgs,
  lib,
  mylib,
  ...
}: {
  imports = mylib.scanPath {path = ./.;};

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
    username = mylib.global.user;
    homeDirectory = "/home/${mylib.global.user}";
    file = {};
    sessionVariables = {};
  };

  home.stateVersion = mylib.global.version;
}
