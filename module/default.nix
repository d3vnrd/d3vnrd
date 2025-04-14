{ config, pkgs, mlib, ... }: {
  # ---General---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Asia/Vietnam";

  # ---Programs---
  programs.zsh.enable = true;

  # ---Global packages---
  environment.systemPackages = with pkgs; [
    neovim
    git 
    gh
    wget
    curl
  ];

  # ---Users---
  users.defaultUserShell = pkgs.zsh;

  # ---Reduce disk usage---
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;

}

