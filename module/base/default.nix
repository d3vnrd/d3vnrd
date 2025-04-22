{ config, pkgs, lib, mylib, myvar, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = lib.mkDefault true;
  time.timeZone = "Asia/Vietnam";

  imports = mylib.scanPath ./.;

  environment.systemPackages = with pkgs; [
    wget
    curl
    gh
  ];

  programs.zsh.enable = lib.mkDefault true;
  users.users."${myvar.user}".shell = lib.mkDefault pkgs.zsh;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2w";
  };
  nix.settings.auto-optimise-store = true;
}

