{
  config,
  lib,
  mylib,
  myvar,
  ...
}: {
  options.M.shell = lib.mkOption {
      default = myvar.shell;
      type = lib.types.enum ["zsh" "bash"];
      description = "Zsh or Bash integrations.";
    };
  };

  imports = mylib.scanPath ./.;

  config = let
    cfg = config.M.shell;
  in
    lib.mkIf cfg.enable {
      programs.zsh.enable = cfg== "zsh";
      programs.starship = {
        enable = true;
        settings = {
          add_newline = true;
          scan_timeout = 10;
        };
        enableZshIntegration = cfg== "zsh";
        enableBashIntegration = cfg== "bash";
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
        enableZshIntegration = cfg== "zsh";
        enableBashIntegration = cfg== "bash";
      };
    };
}
