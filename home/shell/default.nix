{
  config,
  lib,
  ...
}: {
  options.user.shell = {
    enable = lib.mkEnableOption "Enable shell configuration setup.";

    choice = lib.mkOption {
      default = "zsh";
      type = lib.type.enum ["zsh" "bash"];
      description = "Zsh or Bash integrations.";
    };
  };

  config = let
    cfg = config.user.shell;
  in
    lib.mkIf cfg.enable {
      programs.starship = {
        enable = true;
        settings = {
          add_newline = true;
          scan_timeout = true;
        };
        enableZshIntegration = cfg.choice == "zsh";
        enableBashIntegration = cfg.choice == "bash";
      };

      programs.tmux.enable = true;
      xdg.configFile."tmux.conf".source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.xdg.configHome}/nix/home/shell/tmux.conf";
    };
}

