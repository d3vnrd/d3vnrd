{
  config,
  lib,
  mylib,
  ...
}: {
  imports = mylib.scanPath {};

  options.M.shell = lib.mkOption {
    default = mylib.global.shell;
    type = lib.types.enum ["zsh" "bash"];
    description = "Zsh or Bash integrations.";
  };

  config = let
    cfg = config.M.shell;
  in {
    programs.zsh.enable = cfg == "zsh";
    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        scan_timeout = 10;
      };
      enableZshIntegration = cfg == "zsh";
      enableBashIntegration = cfg == "bash";
    };

    programs.zellij = {
      enable = true;
      settings = {
        theme = "kanagawa";
        simplified_ui = true;
        default_shell = cfg;
        default_layout = "compact";
        mouse_mode = false;
      };
      enableZshIntegration = cfg == "zsh";
      enableBashIntegration = cfg == "bash";
    };
  };
}
