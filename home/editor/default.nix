{
  config,
  lib,
  pkgs,
  ...
}: {
  options.user.editor = {
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

  config = lib.mkIf config.user.editor.enable (let
    standalone = config.user.editor.standalone;
    onWsl =
      if standalone
      then false
      else config.user.editor.onWsl;
  in {
      programs.vscode = {
        enable = !(standalone || onWsl);

        # source: https://nixos.wiki/wiki/Visual_Studio_Code (impure setup)
        # Using FHS mode for VSCode to ensure compatibility with system libraries
        # this is necessary for extensions that require system-level dependencies
        # such as Python, C/C++ development, etc. You can install additional
        # packages as needed via VsCode integrated terminal or Python extensions.
        package = pkgs.vscode.fhs;
      };

      # Don't use "mergeAttrsList" cause it will replace home-manger default setting
      programs.neovim = lib.mkMerge [
      	{ 
	  enable = true;
	  viAlias = lib.mkDefault true;
          vimAlias = lib.mkDefault true;
	}
	( lib.mkIf standalone {
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
      ];

      # Symlink Neovim configuration (impure setup)
      xdg.configFile."nvim".source =
          if standalone
          then (config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nix/home/editor/standalone")
          else (config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nix/home/editor/integrated");
    });
}
