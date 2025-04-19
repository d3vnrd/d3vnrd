{ config, lib, pkgs, ... }: {
  options = { zsh.enable = lib.mkEnableOption "Toggle Zshell"; };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;

      autocd = true;
      dotDir = "./config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        path = "$HOME/.zsh_history";
        size = 10000;
        save = 10000;
	share = true;
	append = true;
	saveNoDups = true;
	ignoreSpace = true;
	ignoreDups = true;
	ignoreAllDups = true;
	findNoDups = true;
      };

      shellAliases = {
	ls = "${pkgs.eza}/bin/eza --icons -a --group-directories-first";
        tree = "${pkgs.eza}/bin/eza --color=auto --tree";
      };
    };

    programs.zsh.plugins = import ./plugins.nix;

    programs.zsh.initExtra = ''
      unsetopt BEEP
    '';
  };
}

