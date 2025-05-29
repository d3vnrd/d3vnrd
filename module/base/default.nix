{
  pkgs,
  lib,
  mylib,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = lib.mkDefault true;
  time.timeZone = "Asia/Vietnam";

  imports = mylib.scanPath ./.;

  environment.systemPackages = with pkgs; [
    unzip
    wget
    curl
    gh
    gcc
  ];

  programs.nix-ld.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2w";
  };
  nix.settings.auto-optimise-store = true;
}
