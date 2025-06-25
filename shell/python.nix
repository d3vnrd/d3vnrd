pkgs: {
  packages = with pkgs; [
    python3
    uv
  ];
  shellHook = ''
    echo "Entering Python shell..."
    python3 -V
    uv -V
    exec zsh
  '';
  name = "python";
}
