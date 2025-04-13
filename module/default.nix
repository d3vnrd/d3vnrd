{ config, pkgs, util, ... }: with util;
{
  nix.settings.experimental-features = [ "nix-command" "flake" ]
  time.timeZone = "Asia/Vietnam";
  nixpkgs.config.allowUnfree = true;

  # ---Reduce disk usage---
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;

  # ---Users setting---
  users = {
    users.${myvar.user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    defaultUserShell = pkgs.zsh;
  };

  # ---Default packages---
  environment.systemPackages = with pkgs; [
    neovim 
    git 
    wget
    gh
  ];
  environment.variables.EDITOR = "nvim --clean";
}

