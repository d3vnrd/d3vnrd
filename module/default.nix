{
  pkgs,
  lib,
  myvar,
  ...
}:
with lib; {
  # -- Default system user --
  users.defaultUserShell = pkgs.${myvar.shell};
  users.users.root = {};
  users.users."${myvar.user}" = {
    isNormalUser = lib.mkForce true;
    extraGroups = lib.mkForce ["wheel"];
    description = "Default user for all host machines.";
  };

  # -- Default system packages --
  environment.systemPackages = with pkgs; [
    # utils
    git
    gh
    gcc
    unzip

    # networking
    wget
    curl

    # synchronize
    rsync
  ];

  programs = {
    zsh.enable = mkIf myvar.shell == "zsh"; # default shell
  };

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
