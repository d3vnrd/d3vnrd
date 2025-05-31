{
  config,
  lib,
  pkgs,
  ...
}: {
  options.custom.editor = {
    enable = lib.mkEnableOption "Enable VsCode + Neovim integration.";

    standalone = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable standalone Neovim configuration.";
    };

    onWsl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Wsl suppport.";
    };
  };

  config = builtins.trace "Editor module loaded" (let
    standalone = config.custom.editor.standalone;
    onWsl =
      if standalone
      then false
      else config.custom.editor.onWsl;
  in
    lib.mkIf config.custom.editor.enable {
      programs.vscode = builtins.trace "VsCode evaluate..." ({
        enable = !(standalone || onWsl);

        # source: https://nixos.wiki/wiki/Visual_Studio_Code (impure setup)
        # Using FHS mode for VSCode to ensure compatibility with system libraries
        # this is necessary for extensions that require system-level dependencies
        # such as Python, C/C++ development, etc. You can install additional
        # packages as needed via VsCode integrated terminal or Python extensions.
        package = pkgs.vscode.fhs;
      });

      programs.neovim = builtins.trace "Neovim evaluate..." (lib.mergeAttrsList [
        { enable = true; }
        (lib.mkIf standalone {
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

          viAlias = lib.mkDefault true;
          vimAlias = lib.mkDefault true;
          defaultEditor = lib.mkDefault true;

          extraPackages = with pkgs; [
            # -- Tools require for best neovim experience --
            sqlite
            yarn
            nodejs_22
            tree-sitter

            # -- LSP --
            lua-language-server
            vscode-langservers-extracted
            yaml-language-server
            nixd
            harper
            marksman
            texlab

            # -- DAP --

            # -- Linter --

            # -- Formatter --
            alejandra
            black
            isort
            stylua
            nodePackages.prettier
          ];
        })
      ]);

      # Symlink Neovim configuration (impure setup)
      xdg.configFile."nvim".source =
        if standalone
        then (config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nix/home/editor/standalone")
        else (config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nix/home/editor/integrated");
    });
}
