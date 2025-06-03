{
  config,
  lib,
  ...
}: {
  options.user.shell = {
    enable = lib.mkEnableOption "Enable shell configuration setup.";

    choice = lib.mkOption {
      default = "zsh";
      type = lib.types.enum ["zsh" "bash"];
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
          scan_timeout = 10;
        };
        enableZshIntegration = cfg.choice == "zsh";
        enableBashIntegration = cfg.choice == "bash";
      };

      programs.zellij = {
        enable = true;
        settings.theme = "kanagawa";
        enableZshIntegration = cfg.choice == "zsh";
        enableBashIntegration = cfg.choice == "bash";
      };
    };
}
