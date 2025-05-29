{pkgs}: {
  vscodeExtensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim # Neovim integration for VSCode
      jnoortheen.nix-ide # Nix editing support
  ];
  
  neovimPackages = with pkgs; [
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

    # -- Tools --
    fd
    sqlite
    yarn
    nodejs_22
    tree-sitter
  ];
}
