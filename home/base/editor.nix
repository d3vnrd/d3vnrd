{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.M.editor = mkOption {
    type = types.enum ["nvim" "nvim_vscode" "helix"];
    default = "nvim";
    description = "Editor options.";
  };

  config = let
    cfg = config.M.editor;
  in {
    programs = {
      neovim = mkMerge [
        {
          enable = builtins.elem cfg ["nvim" "nvim_vscode"];
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

      helix = {
        enable = cfg == "helix";
      };
    };

    xdg.configFile."nvim".source = mkIf (cfg == "nvim") (
      config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nix/lib/nvim"
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
  };
}
