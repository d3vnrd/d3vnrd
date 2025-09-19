{
  config,
  lib,
  pkgs,
  helper,
  ...
}:
with lib; {
  imports = helper.scanPath {path = ./.;};

  options.M = {
    addPkgs = mkOption {
      type = with types; listOf package;
      default = [];
      description = "Additional packages (beside default).";
    };
  };

  config = {
    environment.variables.EDITOR = "nvim --clean";
    environment.systemPackages = with pkgs;
      flatten [
        gh
        gcc
        unzip
        direnv
        just

        wget
        curl

        rsync
        neovim

        config.M.addPkgs
      ];

    programs = {
      zsh.enable = mkDefault true;
      git.enable = mkForce true;
    };
  };
}
