{
  config,
  pkgs,
  lib,
  myvar,
  ...
}:
with lib; {
  # -- Default system user --
  users.users.root = {};
  users.users."${myvar.user}" = {
    isNormalUser = mkForce true;
    extraGroups = mkForce ["wheel"];
    description = "Default user for all host machines.";
    shell = pkgs.${myvar.shell};
  };
  # users.defaultUserShell = mkDefault pkgs.${myvar.shell};

  programs = {
    zsh.enable = true;
    git.enable = mkForce true;
  };

  # -- Default system packages --
  environment.systemPackages = with pkgs; [
    # utils
    gh
    gcc
    unzip

    # networking
    wget
    curl

    # synchronize
    rsync
  ];

  # -- Optimize generations --
  nix.gc = {
    automatic = mkForce true;
    dates = mkDefault "weekly";
    options = mkDefault "--delete-older-than 2w";
  };

  nix.settings.auto-optimise-store = mkForce true;
  nix.channel.enable = mkForce false;

  # -- Misc --
  nix.settings.experimental-features = mkForce ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = mkDefault true;
  time.timeZone = mkDefault "Asia/Vietnam";

  # -- Precaution --
  system.stateVersion = mkForce myvar.version;
}
