{
  config,
  lib,
  pkgs,
  ...
}: let
in {
  options.user.editor = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable VsCode + Neovim configuration.";
    };

    # Should i remove this option?
    standalone = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable standalone Neovim configuration.";
    };
  };

  config = lib.mkIf config.user.editor.enable { 
    programs.vscode = {
      enable = lib.mkForce lib.mkIF (config.user.editor.standalone) false true;
      
      # source: https://nixos.wiki/wiki/Visual_Studio_Code (impure setup)
      # Using FHS mode for VSCode to ensure compatibility with system libraries
      # this is necessary for extensions that require system-level dependencies
      # such as Python, C/C++ development, etc. You can install additional
      # packages as needed via VsCode integrated terminal or Python extensions.
      package = pkgs.vscode.fhsWithPackages (ps: with ps; [
          # Installing system-level dependencies in FHS mode
          python3Packages.pip
          zlib
          pkg-config
      ]);
    };
    
    programs.neovim = {
      enable = lib.mkForce true;
    } // lib.mkIf config.user.editor.standalone {
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
        sqlite
        yarn
        nodejs_22
        tree-sitter
      ];
    };

    # Symlink Neovim configuration (impure setup)
    xdg.configFile."nvim".source = lib.mkIf (config.user.editor.standalone)
     (config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nix/home/editor/neovim");
  };

  imports = [ ( import ./packages.nix pkgs ) ];
}
