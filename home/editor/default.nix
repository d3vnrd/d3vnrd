{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [ ./packages.nix ];

  options.user.editor = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable VsCode + Neovim configuration.";
    };

    standalone = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable standalone Neovim configuration.";
    };
  };

  config = lib.mkIf config.user.editor.enable { 
    programs.vscode = {
      enable = lib.mkForce lib.mkIF (config.user.editor.standalone) false true;
      profiles.default = {
        extensions = vscodeExtensions;
        enableExtensionUpdateCheck = lib.mkDefault true;
        enableUpdateCheck = lib.mkDefault true;
        userSettings = "${config.xdg.configHome}/nix/home/editor/vscode/setting.json";
        keybindings = "${config.xdg.configHome}/nix/home/editor/vscode/keymap.json";
      };
    };

    programs.neovim = let enableConfig = config.user.editor.standalone; in {
      enable = lib.mkForce true;
      extraWrapperArgs = [
        "--suffix"
        "LIBRARY_PATH"
        ":"
        "${lib.makeLibraryPath [pkgs.stdenv.cc.cc pkgs.zlib]}"
        "--suffix"
        "PKG_CONFIG_PATH"
        ":"
        "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [pkgs.stdenv.cc.cc pkgs.zlib]}"
      ];

      viAlias = enableConfig;
      vimAlias = enableConfig;
      defaultEditor = enableConfig;

      extraPackages = lib.mkIf enableConfig neovimPackages;
    };

    # Symlink Neovim configuration (impermanent setup)
    xdg.configFile."nvim".source = lib.mkIf (config.user.editor.standalone)
     (config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nix/home/editor/neovim");
  };
}
