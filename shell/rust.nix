pkgs: {
  packages = with pkgs; [
    rustc
    cargo
    clippy
    rustfmt
  ];
  shellHook = ''
    echo "Rust development environment"
    rustc --version
    cargo --version
    exec zsh
  '';
  name = "rust";
}
