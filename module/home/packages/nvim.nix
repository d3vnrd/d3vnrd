{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.M.editor;
in {
  options.M.editor = mkOption {
    type = types.enum ["nvim" "nvim_vscode"];
    default = "nvim";
    description = "Editor options.";
  };

  config = {
    programs = {
      neovim = mkMerge [
        {
          enable = mkDefault true;
          viAlias = mkDefault true;
          vimAlias = mkDefault true;
        }

        (mkIf (cfg == "nvim") {
          defaultEditor = mkDefault true;

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

      vscode = {
        enable = cfg == "nvim_vscode";
        # source: https://nixos.wiki/wiki/Visual_Studio_Code (impure setup)
        package = pkgs.vscode.fhs;
      };
    };

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

    home.activation.checkNvimConfig =
      hm.dag.entryAfter ["writeBoundary"]
      (
        if (cfg == "nvim")
        then ''
          if [ ! -d "${config.xdg.configHome}/nvim" ]; then
            echo "Neovim configuration not found, please install or create one under ${config.xdg.configHome}!"
          fi
        ''
        else ''
          if [ -d "${config.xdg.configHome}/nvim" ]; then
            echo "Neovim configuration was found under ${config.xdg.configHome}/nvim. It is recommended to remove it for the best compatability with VsCode."
          fi
        ''
      );
  };
}
