{
  config,
  lib,
  mylib,
  ...
}: {
  imports = mylib.scanPath ./.;

  options.module.programs = {
    enable = lib.mkOption {
      default = [];
      type = with lib.types; listOf str;
      description = "List of programs to enable config.";
    };
  };

  config = let
    cfg = config.module.programs;
    enable = p: builtins.elem cfg.enable p;
  in {
    programs.yazi = lib.mkIf (enable "yazi") {
      enable = lib.mkDefault true;
      settings = {
        manager = {
          ratio = [0 3 5];
          show_hidden = true;
          sort_by = "extension";
          sort_dir_first = true;
          sort_reverse = true;
          show_symlink = true;
        };
      };
      enableZshIntegration = true;
    };

    programs.lazygit = lib.mkIf (enable "lazygit") {
      enable = lib.mkDefault true;
      settings = {};
    };

    programs.zoxide = lib.mkIf (enable "zoxide") {
      enable = lib.mkDefault true;
      enableZshIntegration = true;
      options = [];
    };

    programs.fzf = lib.mkIf (enable "fzf") {
      enable = lib.mkDefault true;
      enableZshIntegration = true;
    };
  };
}
