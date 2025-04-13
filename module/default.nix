{ config, pkgs, system, lib, util, ... }: with util;
{
  # ---General---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = hostname;
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Asia/Vietnam";

  # ---Users---
  users.users.${myvar.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  users.defaultUserShell = pkgs.zsh;

  # ---Reduce disk usage---
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;

  # ---Packages---
  environment.systemPackages = with pkgs; [
    neovim 
    git 
    gh
    wget
    curl
  ];

  #imports = if (lib.hasSuffix "darwin" system) then [ ./darwin ] else [ ./linux ];
}

