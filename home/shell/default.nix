{
  config,
  lib,
  mylib,
  myvar,
  ...
}: {
  options.module.shell = {
    enable = lib.mkEnableOption "Enable shell configuration setup.";

    choice = lib.mkOption {
      default = myvar.shell;
      type = lib.types.enum ["zsh" "bash"];
      description = "Zsh or Bash integrations.";
    };
  };

  imports = mylib.scanPath ./.;

  config = let
    cfg = config.module.shell;
  in
    lib.mkIf cfg.enable {
      programs.zsh.enable = cfg.choice == "zsh";
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
        settings = {
          theme = "kanagawa";
          simplified_ui = true;
          default_shell = cfg.choice;
          default_layout = "compact";
          mouse_mode = false;
        };
        enableZshIntegration = cfg.choice == "zsh";
        enableBashIntegration = cfg.choice == "bash";
      };
    };
}
