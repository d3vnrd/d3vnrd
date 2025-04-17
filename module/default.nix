{ config, pkgs, ... } @ args: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Asia/Vietnam";

  environment.systemPackages = with pkgs; [
    wget
    curl
  ];

  programs.git = {
    enable = true;
    userName = "tlmp59";
    userEmail = "tinng.imp@gmail.com";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2w";
  };
  nix.settings.auto-optimise-store = true;
}

