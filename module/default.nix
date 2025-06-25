{
  pkgs,
  lib,
  mylib,
  ...
}:
with lib; {
  # -- Default system user --
  users.users.root = {};
  users.users."${mylib.global.user}" = {
    isNormalUser = mkForce true;
    extraGroups = mkForce ["wheel"];
    description = "Default user for all host machines.";
    shell = pkgs.${mylib.global.shell};
  };
  # users.defaultUserShell = mkDefault pkgs.${mylib.global.shell};

  programs = {
    zsh.enable = mkIf (mylib.global.shell == "zsh") (mkForce true);
    git.enable = mkForce true;
  };

  # -- Default system packages --
  environment.systemPackages = with pkgs; [
    # utils
    gh
    gcc
    unzip
    direnv

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
  system.stateVersion = mkForce mylib.global.version;
}
