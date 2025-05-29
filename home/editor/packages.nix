pkgs: {
  home.packages = with pkgs; [
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
}
