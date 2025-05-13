{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.yazi;
in {
  config = lib.mkIf cfg.enable {
    programs.yazi.settings = {
      manager = {
        show_hidden = true;
        sort_by = "extension";
        sort_dir_first = true;
        sort_reverse = true;
        show_symlink = true;
      };
    };

    programs.yazi.enableZshIntegration = true;
  };
}
