{ config, lib, pkgs, ... }: let
  cfg = config.programs.neovim;
  configPath = "${config.xdg.configHome}/nix/home/neovim/config";
in {
  config = lib.mkIf cfg.enable {
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configPath;

    programs.neovim = {
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };

    programs.neovim.extraWrapperArgs = [
      "--suffix"
      "LIBRARY_PATH"
      ":"
      "${lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
      "--suffix"
      "PKG_CONFIG_PATH"
      ":"
      "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
    ];

    home.packages = with pkgs; [
        lua-language-server
    ];
  };
}
