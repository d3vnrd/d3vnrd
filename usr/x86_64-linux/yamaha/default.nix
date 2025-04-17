{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    helix
    tree
  ];

  programs.home-manager.enable = true;
}
