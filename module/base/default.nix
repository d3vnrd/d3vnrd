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
  users.users."${myvar.user}".shell = pkgs.zsh;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2w";
  };
  nix.settings.auto-optimise-store = true;
}

