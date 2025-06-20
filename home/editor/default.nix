{
  config,
  lib,
  pkgs,
  ...
}: {
  options.moduleal.editor = {
    enable = lib.mkEnableOption "User default editor configuration.";

    standalone = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable standalone Neovim configuration.";
    };

    onWsl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Wsl suppport.";
    };
  };

  config = lib.mkIf config.moduleal.editor.enable (let
    standalone = config.moduleal.editor.standalone;
    onWsl =
      if standalone
      then false
      else config.moduleal.editor.onWsl;
  in {
    programs.vscode = {
      enable = !(standalone || onWsl);

      # source: https://nixos.wiki/wiki/Visual_Studio_Code (impure setup)
      package = pkgs.vscode.fhs;
    };

    # Don't use "mergeAttrsList" cause it will replace home-manger default setting
    programs.neovim = lib.mkMerge [
      {
        enable = true;
        viAlias = lib.mkDefault true;
        vimAlias = lib.mkDefault true;
      }
      (lib.mkIf standalone {
        defaultEditor = lib.mkDefault true;

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

        extraPackages = with pkgs; [
          gcc
          tree-sitter
          sqlite
          xclip
          fd
        ];
      })
    ];

    # Symlink Neovim configuration (impure setup)
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink (
      if standalone
      then "${config.xdg.configHome}/nix/home/editor/standalone"
      else "${config.xdg.configHome}/nix/home/editor/integrated"
    );

    home.packages = with pkgs; [
      # -- LSP --
      lua-language-server
      vscode-langservers-extracted
      yaml-language-server
      nixd
      harper
      marksman
      texlab
      pyright

      # -- DAP --

      # -- Linter --

      # -- Formatter --
      alejandra
      black
      dprint
      isort
      stylua
      nodePackages.prettier
    ];
  });
}
