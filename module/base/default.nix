{ config, pkgs, lib, mylib, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Asia/Vietnam";

  imports = mylib.scanPath ./.;

  environment.systemPackages = with pkgs; [
    wget
    curl
    gh
  ];

  programs.zsh.enable = true;
  programs.git.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2w";
  };
  nix.settings.auto-optimise-store = true;
}

